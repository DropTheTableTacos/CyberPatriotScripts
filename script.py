import os

import trio

from utils import apt, ensure_apt

LIGHTDMCONF = """
[Seat:*]
allow-guest=false
""".strip()


async def disable_guest_account():
    async with trio.open_file("/etc/lightdm/lightdm.conf.d/50-no-guest.conf", "w") as f:
        await f.write(LIGHTDMCONF)
        print("Disabled guest account.")


async def install_cracklib():
    await ensure_apt("libpam-cracklib")
    async with trio.open_file("/etc/pam.d/common-password", "r") as f:
        if "pam_cracklib.so" not in f.read():
            raise Exception("Cracklib install failed.")


@apt("augeas-tools", "openssh-server")
async def install_secure_sshd():
    await trio.run_process(["augtool", "-b", "--file=./augtool/sshd.atool"])
    print("Secured ssh")


async def disable_removeable():
    async with trio.open_file(
        "/etc/modprobe.d/disable-usb-storage.conf", "a"
    ) as f0, trio.open_file(
        "/etc/modprobe.d/disable-jffs2.conf", "a"
    ) as f1, trio.open_file(
        "/etc/modprobe.d/disable-cramsfs.conf", "a"
    ) as f2, trio.open_nursery() as nursery:
        await nursery.start_soon(f0.write, "install usb-storage /bin/true")
        await nursery.start_soon(f1.write, "install jffs2 /bin/true")
        await nursery.start_soon(f2.write, "install cramsfs /bin/true")


async def full_user_login():
    async with trio.open_file(
        "/usr/share/lightdm/lightdm.conf.d/50-unity-greeter.conf", "a"
    ) as f:
        await f.write("\ngreeter-hide-users=true\ngreeter-show-manual-login=true")
    await trio.run_process(
        ["gsettings", "set", "com.canonical.unity-greeter", "logo", ""]
    )


async def lockdown_cron():
    os.remove("/etc/cron.deny")
    os.remove("/etc/at.deny")
    async with trio.open_file("/etc/at.allow ", "w") as f0, trio.open_file(
        "/etc/cron.allow ", "w"
    ) as f1, trio.open_nursery() as nursery:
        await nursery.start_soon(f0.write, "root")
        await nursery.start_soon(f1.write, "root")


async def login_defs():
    async with trio.open_file("./login.defs.bak", "w") as backupf, trio.open_file(
        "/etc/logins.defs"
    ) as defsf:
        await backupf.write(await defsf.read())
    async with trio.open_file("/etc/login.defs", "w") as f, trio.open_file(
        "./newlogindefs"
    ) as newdefs:
        await f.write(await newdefs.read())


async def remove_hacking_tools():
    await trio.run_process(["aptdcon", "-p", "john* hydra* aircrack* ophcrack*"])


async def sensitive_file_perms():
    async with trio.open_nursery() as nursery:
        await nursery.start_soon(trio.run_process, ["chmod", "644", "/etc/passwd"])
        await nursery.start_soon(trio.run_process, ["chmod", "640", "/etc/shadow"])
        await nursery.start_soon(trio.run_process, ["chmod", "644", "/etc/group"])

    p = await trio.run_process(["find", "/", "-perm", "-6000"], capture_stdout=True)
    async with trio.open_file("./setuidandsetgid.txt", "wb") as f:
        await f.write(p.stdout)


