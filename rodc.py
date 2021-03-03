#!/usr/bin/python3 -u

import json
import sys
import struct
import subprocess

logfile='/tmp/rodc.log'

raw_length = sys.stdin.buffer.read(4)
if not raw_length:
    sys.exit(0)
msg_length = struct.unpack('=I', raw_length)[0]
msg = sys.stdin.buffer.read(msg_length).decode("utf-8")
msg = json.loads(msg)

with open(logfile,'a') as f:
    f.write(msg['file']+ "\n"+ 
            msg['url'] + "\n"
    )

subprocess.run(['attr','-s','url', '-V', msg['url']])
