#!/bin/bash
sshpass -p admin ssh admin@$1 cat /proc/net/dev | grep ':' | cut -d ':' -f 1 | grep eth
