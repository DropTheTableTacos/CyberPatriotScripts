import multiprocessing as mp
from multiprocessing import Pool as ThreadPool
import magic
import os
import random

def get_immediate_subdirectories(a_dir):
    return [os.path.join(a_dir, name) for name in os.listdir(a_dir)
            if os.path.isdir(os.path.join(a_dir, name))]
def get_immediate_files(a_dir):
    return [os.path.join(a_dir, name) for name in os.listdir(a_dir)
            if os.path.isfile(os.path.join(a_dir, name))]

def worker(folder):
    for banned in ("/proc/","/sys/","/dev/","/lib/","linux-headers","/run/"):
        if banned in folder:
            return []
    try:
        for file in get_immediate_files(folder):
            with magic.Magic(flags=magic.MAGIC_MIME_TYPE) as m:
                try:
                    if m.id_filename(file).split("/") in ("video","image","audio"):
                        print(file)
                except:
                    continue
        return get_immediate_subdirectories(folder)
    except:
        return []
dirs=worker("/")

if __name__ == "__main__":
    pool = ThreadPool(2*len(os.sched_getaffinity(0)))
    while len(dirs)!=0:
        pool = ThreadPool(2*len(os.sched_getaffinity(0)))
        random.shuffle(dirs)
        newdirs=pool.map(worker, dirs)
        pool.close()
        pool.join()
        dirs=[]
        for lis in newdirs:
            for item in lis:
                print("Test:",item)
                dirs.append(item)
