import magic
import os
from os.path import join

filetypes = {}
with magic.Magic(flags=magic.MAGIC_MIME_TYPE) as m:
    for root, dirs, files in os.walk('/'):
        for name in files:
            filetypes[join(root, name)] = m.id_filename(join(root, name))
        for key, value in filetypes.items():
            splitmime = value.split("/")
            if splitmime[0] in ("image","audio","video"):
                if "cache" not in key:
                    print(key)