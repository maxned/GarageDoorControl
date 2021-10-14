#!/usr/bin/env bash

# WiringPi pin 4 is BCM GPIO 23
# Output for transistor to open/close garage
OUT_PIN=4

# File that holds the current state of the garage
STATE_FILE="/home/pi/GarageDoorControl/.state"

# File that holds the current time that the garage was triggered
TIME_FILE="/home/pi/GarageDoorControl/.time"

# File that holds the distance of the garage from the sensor in cm
DISTANCE_FILE="/home/pi/GarageDoorControl/.distance"

# If the garage is closer than this threshold, then it is considered open
DISTANCE_THRESHOLD=100

# How long it takes garage to completely open/close in seconds
MOVING_TIME=12

function set_state()
{
    echo $1 > $STATE_FILE
    STATE=$1
}

function get_state()
{
    STATE=$(cat $STATE_FILE)
    DISTANCE=$(cat $DISTANCE_FILE)
    DISTANCE=${DISTANCE%.*}  # Keep just the integer val

    # Since the .distance file is constantly being written, it can be read as
    # empty, so we need to check if it's a number
    re='^[0-9]+$'
    if ! [[ $DISTANCE =~ $re ]]; then
        set_state $STATE
        return  # Return the same state that was read from the file
    fi

    IS_OPEN=$(( $DISTANCE < $DISTANCE_THRESHOLD ))

    if [[ $IS_OPEN -eq 1 ]]; then
        set_state OPEN
    fi

    # The garage has been manually closed
    if [[ $IS_OPEN -eq 0 ]] && [[ $STATE == OPEN ]]; then
        set_state CLOSING
    fi

    LAST_TRIGGERED=$(cat $TIME_FILE)
    NOW=$(date +%s)
    DIFF=$(( $NOW - $LAST_TRIGGERED ))

    if [[ $DIFF -ge $MOVING_TIME ]] && [[ $STATE == CLOSING ]]; then
        set_state CLOSED
    fi

    if [[ $DIFF -gt $MOVING_TIME ]] && [[ $STATE == OPENING ]]; then
        set_state CLOSED
    fi
}

function trigger_garage()
{
    # Must be manually untriggered later (doing it this way so that the state
    # of the garage can be printed out immediately for better responsiveness of
    # the script)
    gpio write $OUT_PIN 1

    # Save time that the garage was triggered
    echo $(date +%s) > $TIME_FILE
}

if [[ $1 == "setup" ]]; then
    gpio mode $OUT_PIN out
    gpio write $OUT_PIN 0

    echo $(date +%s) > $TIME_FILE
fi

if [[ $1 == "open" ]]; then
    trigger_garage
    set_state OPENING
    echo $STATE

    # Manually set the output back to 0
    sleep 0.5
    gpio write $OUT_PIN 0
fi

if [[ $1 == "close" ]]; then
    trigger_garage
    set_state CLOSING
    echo $STATE

    # Manually set the output back to 0
    sleep 0.5
    gpio write $OUT_PIN 0
fi

if [[ $1 == "state" ]]; then
    get_state
    echo $STATE
fi
