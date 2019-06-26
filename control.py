#!/usr/bin/python3

import rpyc
import sys

if len(sys.argv) > 1:
    garage_control = rpyc.connect("localhost", 18861).root
    
    if sys.argv[1] == "open":
        print(garage_control.open())

    if sys.argv[1] == "close":
        print(garage_control.close())

    if sys.argv[1] == "state":
        print(garage_control.state())
