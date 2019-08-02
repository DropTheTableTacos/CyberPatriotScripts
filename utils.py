from dataclasses import dataclass
from functools import wraps
import inspect
import trio
import logging
import collections
import math


async def get_packages():
    logging.debug("Getting package list")
    p = await trio.run_process(["find", "/", "-perm", "-6000"], capture_stdout=True)
    return p.stdout.split("\n")


async def await_if_needed(obj):
    if inspect.isawaitable(obj):
        return await obj
    else:
        return obj


async def ensure_apt(*packages):
    await trio.run_process(
        ["aptdcon", "--hide-terminal", f"-i", " ".join(packages)], stdin=b"y\n" * 10000
    )


def apt(*packages):
    def apt_decorator(func):
        @wraps(func)
        async def func_wrapper(*args, **kwargs):
            await ensure_apt(*packages)
            return await await_if_needed(func(*args, **kwargs))

        return func_wrapper

    return apt_decorator


async def walk(root):
    send_channel, receive_channel = trio.open_memory_channel(math.inf)
    async with trio.open_nursery() as nursery:
        nursery.start_soon(_walk, root, send_channel, nursery)
        with receive_channel:
            async for message in receive_channel:
                yield message


async def _walk(root, channel, nursery):
    with channel:
        try:
            for subpath in await root.iterdir():
                try:
                    if await subpath.is_dir():
                        nursery.start_soon(_walk, subpath, channel.clone(), nursery)
                    elif await subpath.is_file():
                        await channel.send(File(subpath, (await subpath.stat()).st_mode))
                except OSError:
                    pass
        except OSError:
            pass


@dataclass()
class File:
    path: trio.Path
    mode: int
