from functools import wraps
import inspect
import trio


async def await_if_needed(obj):
    if inspect.isawaitable(obj):
        return await obj
    else:
        return obj


async def ensure_apt(*packages):
    await trio.run_process(["aptdcon", f"-i \"{' '.join(packages)}\""])


def apt(*packages):
    def apt_decorator(func):
        @wraps(func)
        async def func_wrapper(*args, **kwargs):
            await ensure_apt(*packages)
            return await await_if_needed(func(*args, **kwargs))
        return func_wrapper
    return apt_decorator
