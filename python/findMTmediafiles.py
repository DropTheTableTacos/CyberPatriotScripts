import multiprocessing as mp
from multiprocessing import Pool as ThreadPool
import magic
import os
import random
from getFiles import getFiles
import logging

logging.basicConfig(filename="findmediafiles.log",level=logging.DEBUG)


def worker(file):
    logging.debug("Working on file: {0}".format(file))
    for banned in ("firefox","/etc/","/dev/"):
        if banned in file:
            return None
    try:
        with magic.Magic(flags=magic.MAGIC_MIME_TYPE) as m:
            try:
                if m.id_filename(file).split("/") in ("video","image","audio"):
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
       f.writelines([x for x in mediafiles if x is not None])
    for file in [x for x in mediafiles if x is not None]:
        print(file)
        #dirs=[]
        #for lis in newdirs:
        #    for item in lis:
        #        dirs.append(item)
