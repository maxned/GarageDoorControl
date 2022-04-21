# WiringPi pin 1 is GPIO 18
GPIO_TRIGGER=1

# WiringPi pin 5 is GPIO 24
GPIO_ECHO=5

gpio mode $GPIO_TRIGGER out
gpio write $GPIO_TRIGGER 0

gpio mode $GPIO_ECHO in
gpio mode $GPIO_ECHO up

gpio write $GPIO_TRIGGER 1
sleep 0.00001  # Set trigger to LOW after 0.01ms
gpio write $GPIO_TRIGGER 0

START_TIME=0
STOP_TIME=0

while [[ $(gpio read $GPIO_ECHO) -eq 0 ]]; do
  # START_TIME=$(date +%s)
  echo "hit"
  # echo "read"
  # sleep 1
done

while [[ $(gpio read $GPIO_ECHO) -eq 1 ]]; do
  # STOP_TIME=$(date +%s)
  echo "2"
  # sleep 1
done

echo "got here"

TIME_ELAPSED=$(( $STOP_TIME - $START_TIME ))
DISTANCE=$(( ($TIME_ELAPSED * 34300) / 2 ))

echo $DISTANCE

# Reset pins back to input mode to not accidentally output something
gpio mode $GPIO_TRIGGER in
gpio mode $GPIO_ECHO in
