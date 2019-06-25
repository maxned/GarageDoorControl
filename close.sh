PID=$(ps -aef | grep 'garage_control.py' | grep -v 'grep' | awk '{ print $2 }')
if [[ -n "$PID" ]]; then
    kill -s SIGUSR2 $PID
fi