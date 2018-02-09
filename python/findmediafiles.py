import magic
import os
from os.path import join

filetypes = {}
oldkeys = []
with magic.Magic(flags=magic.MAGIC_MIME_TYPE) as m:
    for root, dirs, files in os.walk('/'):
        isUsed=False
        for dir in ("sys","proc"):
            if dir in root:
                break
                isUsed=True
        if isUsed:
            continue
        for name in files:
            if join(root, name) not in oldkeys:
                filetypes[join(root, name)] = m.id_filename(join(root, name))
        for key, value in filetypes.items():
            splitmime = value.split("/")
            if splitmime[0] in ("image","audio","video"):
                print(key)
        for key in filetypes.keys():
            oldkeys.append(key)
        for key in oldkeys:
            if key in filetypes.keys():
                del filetypes[key]
