#!/usr/bin/env python3

import os
import requests
from typing import Optional, List

hostsLists = [
    # Ads
    'https://raw.githubusercontent.com/AdAway/adaway.github.io/master/hosts.txt',
    'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext&useip=0.0.0.0',

    # Misc
    'http://someonewhocares.org/hosts/zero/hosts',

    # Malware
    'http://www.malwaredomainlist.com/hostslist/hosts.txt'
]

def extractHost(inp: str) -> Optional[str]:
    # Extract the host, IE:
    # 127.0.0.1 google.com #comment
    # turns into "google.com"
    space = inp.find(' ') + 1

    # there is no space, meaning it can't follow the format
    if space == 0:
        return None
    
    comment = inp.find('#')

    # places where the first space is after the comment
    # meaning it can't be a domain
    if comment < space and comment != -1:
        return None

    # extract the host
    if comment == -1:
        inp = inp[space:]
    else:
        inp = inp[space:comment]

    inp = inp.strip()

    # Return None if domain not found
    if inp == '':
        return None

    return inp

def downloadHostFile(location: str) -> List[str]:
    return requests.get(location).text.splitlines()

def main():
    hostnames = set()

    for hosts in hostsLists:
        # get hosts from the url to an array of lines of hosts
        hosts = downloadHostFile(hosts)

        # separate hosts into a list of hostnames
        hosts = map(extractHost, hosts)

        # add list of hostnames to the running sum of hostnames
        hostnames |= set(hosts)

    # Someone who cares has the following set
    hostnames -= set([
        'localhost',
        'local',
        'localdomain',
        'broadcasthost',
        'localhost.localdomain',

        # Remove failed values
        None
    ])

    hostnames = sorted(list(hostnames))
    
    hostsFile = map(lambda x: "0.0.0.0 " + x + "\n", hostnames)

    path = os.path.dirname(os.path.realpath(__file__))
    with open(path + '/hosts','w') as f:
        f.write("""
#===DO NOT ADD HOSTS BELOW THIS LINE===

# This file comes from the combination of several different hosts files
# Thank you to:
#
## Kicelo, Dominik Schuermann from AdAway
### https://github.com/AdAway/adaway.github.io/blob/master/hosts.txt
#
## Peter Lowe from yoyo.org
### https://pgl.yoyo.org/adservers/
#
## Dan Pollock from someonewhocares.org
### http://someonewhocares.org/hosts/zero/
#
## Everyone from malwaredomainlist.com
### http://www.malwaredomainlist.com/forums/index.php?topic=3270.0
#
# Without them, this file would not be possible

""")

        # Write to file all of the hostsFiles
        f.writelines(hostsFile)
        f.write("#===DO NOT ADD HOSTS ABOVE THIS LINE===\n")
    

if __name__ == '__main__':
    main()