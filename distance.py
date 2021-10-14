# Code copied from https://tutorials-raspberrypi.com/raspberry-pi-ultrasonic-sensor-hc-sr04/

# I originally tried rewriting this into a bash script but had issues dealing
# with the echo signal, so I gave up and will go with this approach. The goal
# is for the state get function to be as quick as possible, and loading the
# python script takes longer than I want it to.

import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

GPIO_TRIGGER = 18
GPIO_ECHO = 15

GPIO.setup(GPIO_TRIGGER, GPIO.OUT)
GPIO.setup(GPIO_ECHO, GPIO.IN)

def distance():
    GPIO.output(GPIO_TRIGGER, True)
    time.sleep(0.00001)  # Need to wait at least 0.01ms
    GPIO.output(GPIO_TRIGGER, False)

    StartTime = time.time()
    StopTime = time.time()

    while GPIO.input(GPIO_ECHO) == 0:
        StartTime = time.time()

    while GPIO.input(GPIO_ECHO) == 1:
        StopTime = time.time()

    # Multiply by the speed of sound and divide by 2 because the sound
    # goes there and back
    TimeElapsed = StopTime - StartTime
    distance = (TimeElapsed * 34300) / 2

    return distance  # Unit is cm

if __name__ == '__main__':
    try:
        while True:
            # Write to a .distance file so that other programs can always read the distance
            # Distance is in cm
            with open('/home/pi/GarageDoorControl/.distance', 'w') as f:
              f.write(str(distance()))
            time.sleep(0.5)

    except KeyboardInterrupt:
        GPIO.cleanup()
