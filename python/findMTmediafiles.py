import multiprocessing as mp
from multiprocessing import Pool as ThreadPool
import magic
import os
import random
from getFiles import getFiles
import logging

logging.basicConfig(filename="findmediafiles.log",level=logging.DEBUG)

bannedtypes=("firefox",
             "/etc/",
             "/dev/",
             "/lib/firmware/yam/",
             ".bash_it/themes",
             ".cache/",
             "/var/lib/app-info/icons",
             "/usr/lib/",
             "/usr/share/",
             )

def worker(file):
    logging.debug("Working on file: {0}".format(file))
    for banned in bannedtypes:
        if banned in file:
            return None
    try:
        with magic.Magic(flags=magic.MAGIC_MIME_TYPE) as m:
            try:
                if m.id_filename(file).split("/")[0] in ("video","image","audio"):
                    logging.info("{0} is a media file!!!".format(file))
                    print(file)
                    return file
            except:
                return None
            return None
    except:
        return None


if __name__ == "__main__":
    pool = ThreadPool(2*len(os.sched_getaffinity(0)))
    allfiles = getFiles()
    logging.debug("Allfiles is {0} elements long".format(len(allfiles)))
    mediafiles = pool.map(worker, allfiles)
    pool.close()
    pool.join()

    with open("mediafiles.txt",'w') as f:
        for file in [x for x in mediafiles if x is not None]:
            f.write(file+"\n")
            print(file)
        #dirs=[]
        #for lis in newdirs:
        #    for item in lis:
        #        dirs.append(item)
