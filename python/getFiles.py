import os
from os import path
import pickle
import pprint
    

def getFiles():
    data = []
    if path.isfile(path.join(os.path.dirname(path.abspath(__file__)),"files.dat")):
        print("Loading from the cached file list")
        with open(path.join(os.path.dirname(path.abspath(__file__)),"files.dat"), 'rb') as f:
            data=pickle.load(f)
    else:
        print("Constructing file list")
        for root, _, files in os.walk("/"):
            for f in files:
                fullpath = os.path.join(root, f)
                data.append(fullpath)
        with open(path.join(os.path.dirname(path.abspath(__file__)),"files.dat"),'wb') as f:
            pickle.dump(data,f)
    return data

if __name__ == '__main__':
    for file in getFiles():
        print(file)
