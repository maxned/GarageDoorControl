#!/usr/bin/env bash

# WiringPi pin 4 is GPIO 23
# Output for transistor to open/close garage
OUT_PIN=4

# WiringPi pin 5 is GPIO 24
# Input switch will go to ground when the garage is completely open
IN_PIN=5

# File that holds the current state of the garage
STATE_FILE=".state"

# File that holds the current time that the garage was triggered
TIME_FILE=".time"

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

    # When false, garage door is open
    if [[ $(gpio read $IN_PIN) -eq 0 ]]; then
        set_state OPEN
    fi

    # The garage has been manually closed
    if [[ $(gpio read $IN_PIN) -eq 1 ]] && [[ $STATE == OPEN ]] ; then
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

    gpio mode $IN_PIN in
    gpio mode $IN_PIN up

    # When false, garage door is open
    if [[ ! $(gpio read $IN_PIN) ]]; then
        set_state OPEN
    else
        set_state CLOSED
    fi

    echo $(date +%s) > $TIME_FILE
fi

if [[ $1 == "open" ]]; then
    get_state

    if [[ $STATE == CLOSED ]]; then
        trigger_garage
        set_state OPENING
    fi

    echo $STATE

    # Manually set the output back to 0
    sleep 0.5
    gpio write $OUT_PIN 0
fi

if [[ $1 == "close" ]]; then
    get_state

    if [[ $STATE == OPEN ]]; then
        trigger_garage
        set_state CLOSING
    fi

    echo $STATE

    # Manually set the output back to 0
    sleep 0.5
    gpio write $OUT_PIN 0
fi

if [[ $1 == "state" ]]; then
    get_state
    echo $STATE
fi
