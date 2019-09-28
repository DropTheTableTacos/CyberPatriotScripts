import os
from dataclasses import dataclass
from functools import wraps
import inspect
from typing import List, Tuple, AsyncIterator, T

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
    for root, dirs, files in os.walk('python/Lib/email'):
        for fn in files:
            path = trio.Path(root) / fn
            mode = await path.stat().st_mode
            yield File(path=path, mode=mode)



@dataclass()
class File:
    path: trio.Path
    mode: int


async def async_tee(itr, n: int):
    sentinel = object()

    queues: List[Tuple[trio.abc.Channel]] = [trio.open_memory_channel(0) for k in range(n)]

    async def gen(k: int, q: Tuple[trio.abc.Channel]) -> AsyncIterator[T]:
        if k == 0:
            async for value in iter(itr):
                async with trio.open_nursery() as nursery:
                    for send_channel, _ in queues[1:]:
                        nursery.start_soon(send_channel.send, value)
                yield value

            async with trio.open_nursery() as nursery:
                for send_channel, _ in queues[1:]:
                    nursery.start_soon(send_channel.send, sentinel)

        else:
            while True:
                value = await q[1].recieve()
                if value is sentinel:
                    break
                yield value
