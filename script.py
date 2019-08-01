import os

import trio

from utils import apt, ensure_apt, walk

import logging
import stat
from subprocess import CalledProcessError, DEVNULL
import math

LIGHTDMCONF = """
[Seat:*]
allow-guest=false
""".strip()

FIND_LOCK = trio.Lock()

logging.basicConfig(level=logging.DEBUG, format="%(asctime)s [%(levelname)s] (%(funcName)s) %(message)s")


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
    async with await trio.open_file("./login.defs.bak", "w") as backupf, await trio.open_file(
        "/etc/login.defs"
    ) as defsf:
        await backupf.write(await defsf.read())
    logging.info("Writing new login.defs")
    async with await trio.open_file("/etc/login.defs", "w") as f, await trio.open_file(
        "./newlogin.defs"
    ) as newdefs:
        await f.write(await newdefs.read())
    logging.info("login.defs secured.")

async def remove_hacking_tools():
    for package in ("john", "hydra", "aircrack-ng", "ophcrack"):
        logging.info(f"Removing {package}")
        await trio.run_process(["aptdcon", "--hide-terminal", "-p", package], check=False, stdin=b"y\n"*10000)
    logging.info("Hacking tools removed")

async def sensitive_file_perms():
    logging.info("Chmodding /etc/passwd /etc/shadow /etc/group")
    async with trio.open_nursery() as nursery:
        nursery.start_soon(trio.run_process, ["chmod", "644", "/etc/passwd"])
        nursery.start_soon(trio.run_process, ["chmod", "640", "/etc/shadow"])
        nursery.start_soon(trio.run_process, ["chmod", "644", "/etc/group"])
    
    logging.info("Waiting for find lock...")
    async with FIND_LOCK:
        logging.info("Finding sensitive permissioned files")
        # p = await trio.run_process(["find", "/", "-perm", "-6000"], capture_stdout=True, check=False, stderr=DEVNULL)
        async with await trio.open_file("./setuidandsetgid.txt", "w") as f:        
            send_channel, receive_channel = trio.open_memory_channel(math.inf)
            async with trio.open_nursery() as nursery:
                nursery.start_soon(walk, trio.Path("/"), send_channel)
                while True:
                     path = await receive_channel.receive()
                     if path is None:
                         break
                     try:
                        if (await path.stat()).st_mode & (stat.S_ISUID | stat.S_ISGID):
                            await f.write(f"{path}\n")
                     except FileNotFoundError:
                        pass

async def main():
    async with trio.open_nursery() as nursery:
        nursery.start_soon(disable_guest_account)
        nursery.start_soon(remove_hacking_tools)
        nursery.start_soon(sensitive_file_perms)
        nursery.start_soon(disable_removeable)
        nursery.start_soon(login_defs)
        nursery.start_soon(install_cracklib)
        nursery.start_soon(lockdown_cron)
        nursery.start_soon(full_user_login)

trio.run(main)

