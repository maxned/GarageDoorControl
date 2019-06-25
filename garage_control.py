#!/usr/bin/python3

import gpiozero
import signal
import time
import enum
from datetime import datetime

# State of garage door
current_state = None

# Time it takes garage to open or close and subsequently how long current_state
# will be in either the OPENING or CLOSING states
moving_time = 12

started_moving_time = None

class State(enum.Enum):
    OPEN = 1
    OPENING = 2
    CLOSED = 3
    CLOSING = 4

def trigger_garage():
    output_pin.on()
    time.sleep(0.25)
    output_pin.off()

def open_garage(signum, frame):
    trigger_garage()
    
    started_moving_time = datetime.now()
    global current_state
    current_state = State.OPENING

    # For the Homebridge plugin
    print(current_state.name)

def close_garage(signum, frame):
    trigger_garage()

    started_moving_time = datetime.now()
    global current_state
    current_state = State.CLOSING

    # For the Homebridge plugin
    print(current_state.name)

def garage_state(signum, frame):
    global current_state
    delta = datetime.now() - started_moving_time

    if current_state == State.CLOSING and delta.seconds >= moving_time:
        current_state = State.CLOSED

    # For the Homebridge plugin
    print(current_state.name)

def garage_opened():
    global current_state
    current_state = State.OPEN

def garage_closing():
    global current_state
    current_state = State.CLOSING
    started_moving_time = datetime.now()

if __name__== "__main__":
    # Setting this HIGH will make the garage door open/close
    output_pin = gpiozero.DigitalOutputDevice("GPIO23", initial_value=False)

    # Input switch will go to ground when the garage is completely open
    input_switch = gpiozero.DigitalInputDevice("GPIO24", pull_up=True, bounce_time=0.1)
    input_switch.when_activated = garage_opened
    input_switch.when_deactivated = garage_closing

    # Set default values
    if input_switch.value == True:
        current_state = State.OPEN
    else:
        current_state = State.CLOSED

    started_moving_time = datetime.now()

    # Respond to commands from the Homebridge plugin
    signal.signal(signal.SIGUSR1, open_garage)
    signal.signal(signal.SIGUSR2, close_garage)
    signal.signal(signal.SIGQUIT, garage_state)

    print("started")

    while True:
        signal.pause()