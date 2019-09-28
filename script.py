import os

import trio

from utils import apt, ensure_apt, walk, async_tee

import logging
import stat
from subprocess import CalledProcessError, DEVNULL
import math
import random
import string

LIGHTDMCONF = """
[Seat:*]
allow-guest=false
""".strip()

FIND_LOCK = trio.Lock()

logging.basicConfig(
    level=logging.DEBUG, format="%(asctime)s [%(levelname)s] (%(funcName)s) %(message)s"
)


async def disable_guest_account():
    path = trio.Path("/etc/lightdm/lightdm.conf.d/50-no-guest.conf")
    await path.parent.mkdir(parents=True, exist_ok=True)
    async with await path.open("w") as f:
        await f.write(LIGHTDMCONF)
    logging.info("Guest account disabled")


async def install_cracklib():
    await ensure_apt("libpam-cracklib")
    async with await trio.open_file("/etc/pam.d/common-password", "r") as f:
        if "pam_cracklib.so" not in await f.read():
            raise Exception("Cracklib install failed.")
    logging.info("Installed cracklib")


@apt("augeas-tools", "openssh-server")
async def install_secure_sshd():
    await trio.run_process(["augtool", "-b", "--file=./augtool/sshd.atool"])
    logging.info("SSH installed and secured.")


async def disable_removeable():
    async with await trio.open_file(
        "/etc/modprobe.d/disable-usb-storage.conf", "a"
    ) as f0, await trio.open_file(
        "/etc/modprobe.d/disable-jffs2.conf", "a"
    ) as f1, await trio.open_file(
        "/etc/modprobe.d/disable-cramsfs.conf", "a"
    ) as f2, trio.open_nursery() as nursery:
        nursery.start_soon(f0.write, "install usb-storage /bin/true")
        nursery.start_soon(f1.write, "install jffs2 /bin/true")
        nursery.start_soon(f2.write, "install cramsfs /bin/true")
    logging.info("Disabled removeable devices")


async def full_user_login():
    logging.debug("Forcing manual login...")
    async with await trio.open_file(
        "/usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf", "a"
    ) as f:
        await f.write("\ngreeter-hide-users=true\ngreeter-show-manual-login=true")
    logging.debug("Removing the logo")
    await trio.run_process(
        ["gsettings", "set", "com.canonical.unity-greeter", "logo", ""]
    )
    logging.info("Finished setting up full user login")


async def lockdown_cron():
    logging.debug("Removing cron/at deny files")
    etc = trio.Path("/etc")

    if await (etc / "cron.deny").exists():
        await (etc / "cron.deny").unlink()
    if await (etc / "at.deny").exists():
        await (etc / "at.deny").unlink()

    logging.debug("Setting cron/at allow to root...")
    async with await trio.open_file("/etc/at.allow", "w") as f0, await trio.open_file(
        "/etc/cron.allow", "w"
    ) as f1, trio.open_nursery() as nursery:
        nursery.start_soon(f0.write, "root")
        nursery.start_soon(f1.write, "root")
    logging.info("Locked down root.")


async def login_defs():
    logging.info("Backing up login.defs")
    async with await trio.open_file(
        "./login.defs.bak", "w"
    ) as backupf, await trio.open_file("/etc/login.defs") as defsf:
        await backupf.write(await defsf.read())
    logging.info("Writing new login.defs")
    async with await trio.open_file("/etc/login.defs", "w") as f, await trio.open_file(
        "./newlogin.defs"
    ) as newdefs:
        await f.write(await newdefs.read())
    logging.info("login.defs secured.")


async def remove_hacking_tools():
    for package in ("john", "hydra", "aircrack-ng", "ophcrack", "netcat-traditional"):
        logging.info(f"Removing {package}")
        await trio.run_process(
            ["aptdcon", "--hide-terminal", "-p", package],
            check=False,
            stdin=b"y\n" * 10000,
        )
    logging.info("Hacking tools removed")


async def sensitive_file_perms(channel):
    logging.info("Chmodding /etc/passwd /etc/shadow /etc/group")
    async with trio.open_nursery() as nursery:
        nursery.start_soon(trio.run_process, ["chmod", "644", "/etc/passwd"])
        nursery.start_soon(trio.run_process, ["chmod", "640", "/etc/shadow"])
        nursery.start_soon(trio.run_process, ["chmod", "644", "/etc/group"])

    logging.info("Waiting for find lock...")
    async with FIND_LOCK:
        logging.info("Finding sensitive permissioned files")
        # p = await trio.run_process(["find", "/", "-perm", "-6000"], capture_stdout=True, check=False, stderr=DEVNULL)
        files = [str(x.path) async for x in channel[1] if x.mode & (stat.S_ISUID | stat.S_ISGID)]
        async with await trio.open_file("./setuidandsetgid.txt", "w") as f:
            await f.write("\n".join(files))

def password_gen():
    passwd = ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(16))
    return passwd.encode()

async def lock_root_account():
    logging.info("Changing root password...")
    await trio.run_process(["chpasswd"], stdin=b"root:"+password_gen())
    logging.info("Locking root account...")
    await trio.run_process(["passwd", "-dl", "root"])

async def password_based():
    logging.info("Root account must be locked before cracklib is installed")
    await lock_root_account()
    logging.info("Installing cracklib")
    await install_cracklib()

async def find_media_files(channel):
    headers = (
        b"RIFF",
        b"\xff\xfb",
        b"ID3",
        b"OggS",
        b"fLaC",
    )
    potential_media_files = []
    async with await trio.open_file("./mediafiles.txt", "w") as f1:
        for file in channel[1]:
            async with await file.path.open('rb') as f:
                firstbytes: bytes = await f.read(16)
                for header in headers:
                    if firstbytes.startswith(header):
                        await f1.write("str(file.path)\n")

async def main():
    async with trio.open_nursery() as nursery:
        all_files_channels = await async_tee(walk("/"), 2)
        nursery.start_soon(disable_guest_account)
        nursery.start_soon(remove_hacking_tools)
        nursery.start_soon(sensitive_file_perms, all_files_channels[0])
        nursery.start_soon(find_media_files, all_files_channels[1])
        nursery.start_soon(disable_removeable)
        nursery.start_soon(login_defs)
        nursery.start_soon(password_based)
        nursery.start_soon(lockdown_cron)
        nursery.start_soon(full_user_login)


trio.run(main)
