#!/usr/bin/python3

import gpiozero
import signal
import time

output_pin = gpiozero.DigitalOutputDevice("GPIO23", initial_value=False)

def open_garage(signum, frame):
    output_pin.on()
    time.sleep(0.25)
    output_pin.off()
    print("trigger")

def close_garage(signum, frame):
    output_pin.on()
    time.sleep(0.25)
    output_pin.off()
    print("trigger")

def garage_state(signum, frame):
    print("why hello")

signal.signal(signal.SIGUSR1, open_garage)
signal.signal(signal.SIGUSR2, close_garage)
signal.signal(signal.SIGQUIT, garage_state)

while True:
    signal.pause()