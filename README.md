﻿# Usage
   Usage ./findipaddrs.sh DIRECTORY [-u IP_ADDR | -p IP_ADDR]

Required:

	DIRECTORY: The starting directory. This directory will be traversed recursively.

Options:

	None/Default: Find the number of times any IP Address passed in occurs in any file in the directories below

	-u: Find the number of times a passed ip address occurs in each file in the directory

	-p: Find the number of times a passed ip address occurs in each file in the directory

	IP_ADDR: IPv4 address in dot-decimal notation

# Description
The findipaddr’s shell script will begin at the directory provided searching for either a specified Ipv4 address or any Ipv4 address found while traversing the supplied directory recursively.

