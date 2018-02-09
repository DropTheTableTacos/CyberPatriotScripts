from multiprocessing import Pool
import re
import magic
import os
from getFiles import getFiles
import logging

logging.basicConfig(level=logging.DEBUG)
logging.disable(logging.DEBUG)

sencontains = (
                "Social Security",
                "Social Security#",
                "Soc Sec",
                "SSN",
                "SSNS",
                "SSN#",
                "SS#",
                "SSID",
                "card verification",
                "card identification number",
                "cvn",
                "cid",
                "Password",
                "Salery",
                "Visa",
                "mastercard",
                "credit card",
                "card number",
                "Starting nmap",
                "KEY FOUND!",
              )


senregexes = (
                re.compile(r'\d{14}'),
                re.compile(r'\d{3}[ \-]?\d{3}[ \-]?\d{3}'),
                re.compile(r'([0-F]{2}:){5}[0-F]{2}'),

                ## JOHN THE RIPPER FINGERPRINTS

                re.compile(r'Loaded .* password hash(es)?'),
                re.compile(r'guesses: \d+  time: \d+:\d+:\d+:\d+ \d?\d?\d% ....: \d+  trying: .* -.*'),

                ## HYDRA FINGERPRINTS

                re.compile(r'^Hydra v.{3} \(c\) \d{4}'),
                re.compile(r'\[.+\] \d+\.\d\d tries/min, \d+ tries in \d\d:\d\d., \d+ todo in \d\d:\d\d.'),

                ## NCRACK FINGERPRINTS

                re.compile(r'^Starting Ncrack .* \( ?http://ncrack.org ?\) at \d\d\d\d-\d\d-\d\d \d\d:\d\d ...$'),
                re.compile(r'Stats: \d+:\d+:\d+ elapsed; \d+ services completed \(\d+ total\)'),

                ## MEDUSA FINGERPRINTS

                re.compile(r'Medusa v\d\.\d \[http://www.foofus.net] \(C\).*'),
                re.compile(r'ACCOUNT [A-Z]+: \[.+\]'),

                ## NMAP FINGERPRINTS

                re.compile(r'Starting Nmap \d\.\d\d \( ?https?://nmap\.org \) at \d\d\d\d-\d\d-\d\d \d\d:\d\d ...'),
                re.compile(r'Scanning .* \(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\) \[\d+ ports\]'),
                re.compile(r'Discovered open port \d{1,5}/[tu]cp on \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'),
                re.compile(r'(About)? \d{1,3}.\d\d% done; ETC: \d\d:\d\d \(\d:\d\d:\d\d remaining\)'),

                ## AIRCRACK-NG FINGERPRINTS

                re.compile(r'([0-F]{2}:){5}[0-F]{2} -\d\d \d{1,3} \d{1,3} \d{1,3} \d{1,3} \d{1,3}e?\.? .{,4} (CCMP )?(PSK )?.*'),
                re.compile(r'([0-F]{2}:){5}[0-F]{2} -\d\d \d{1,3} \d{1,3} \d{1,3} \d{1,3} \d{1,3}e?\.? .{,4} (CCMP )?(PSK )?.*'),


                )


def workerFindText(file):
    for banned in ("/sys/",
                   "/dev/",
                   "/proc/",
                   "headers",
                   "desktop",
                   ".py",
                   "/var/lib/apt",
                   "/var/lib/dpkg",
                   ".mozilla/firefox/",
                   "/var/l",
                   "/var/backups/",
                   "/var/cache/"
                   "/run",
                   "/etc",
                   "/lib",
                   "/usr",
                   "/boot",
                   "/.cache",
                   ".bash_it",
                   "CyberPatriotScripts",
                   ".local/share"
                   ):
        if banned in file:
            logging.debug("Skipping file: {0}".format(file))
            return None
    if file.endswith(".h"):
        return None
    logging.debug("Typechecking file: {0}".format(file))
    # for banned in banned:
    #     if banned in file:
    #         return None

    try:
        with magic.Magic(flags=magic.MAGIC_MIME_TYPE) as m:
            try:
                if m.id_filename(file)=="text/plain":
                    logging.info("{0} is a text file... will search".format(file))
                    isSens = False
                    with open(file) as f:
                        for _, line in enumerate(f):
                            for contain in sencontains:
                                if contain.lower() in line.lower():
                                    logging.debug("{0} contained sensitive contain {1}".format(file, contain))
                                    isSens = True
                            for regex in senregexes:
                                if regex.search(line) != None:
                                    logging.debug("{0} contained sensitive regex {1}".format(file, regex.pattern))
                                    isSens = True
                    if isSens:
                        return file if (not file.startswith("/run")) and (not file.startswith("/var/cache")) else None
                    else:
                        return None
            except:
                return None
            return None
    except:
        return None

# def workerScanText(file):
#     for banned in ("/sys/","/dev/","/proc/", "headers", ".desktop"):
#         if banned in file:
#             logging.debug("Skipping file: {0}".format(file))
#             return None
#     if ".h" in file or ".svg" in file:
#         return None
#     logging.debug("Scanning on file: {0}".format(file))
#     try:
#         isSens = False
#         with open(file) as f:
#             for _, line in enumerate(f):
#                 for contain in sencontains:
#                     if contain.lower() in line.lower():
#                         logging.debug("{0} contained sensitive contain {1}".format(file,contain))
#                         isSens=True
#                 for regex in senregexes:
#                     if regex.search(line) != None:
#                         logging.debug("{0} contained sensitive regex {1}".format(file, regex.pattern))
#                         isSens=True
#         if isSens:
#             return file
#         else:
#             return None
#     except:
#         return None



if __name__ == "__main__":
    pool = Pool(2*len(os.sched_getaffinity(0)))
    allfiles = getFiles()
    logging.debug("Allfiles is {0} elements long".format(len(allfiles)))
    textfiles = pool.map(workerFindText, allfiles)
    pool.close()
    pool.join()
    textfiles = [x for x in textfiles if x is not None]
    with open("sensitivefiles.txt",'w') as f:
        for file in [x for x in textfiles if x is not None]:
            f.write(file+"\n")
            print(file)
