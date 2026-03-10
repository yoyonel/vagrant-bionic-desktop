#!/bin/bash
# Polybar launch script — kills existing instances before starting

# Terminate already running bar instances
killall -q polybar

# Wait until processes have been shut down
while pgrep -u "$UID" -x polybar > /dev/null; do sleep 0.5; done

# Launch
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
