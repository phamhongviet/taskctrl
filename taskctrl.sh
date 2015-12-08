#!/bin/bash

WORK_DIR=/tmp/taskctrl
SLEEP_DURATION=2
MAX_LOAD=5

get_state() {
	if [ -f $WORK_DIR/state ]; then
		cat $WORK_DIR/state
	else
		echo run
	fi
}

# never heard of Ctrl-C
check_stop() {
	local state=`get_state`
    if [ "$state" == stop ]; then
        break
    fi
}

# never heard of Ctrl-Z
check_pause() {
	local state=`get_state`
    if [ "$state" == pause ]; then
        sleep $SLEEP_DURATION
        continue
    fi
}

# go to sleep until load is low enough
check_load() {
	local load=`cat /proc/loadavg | cut -d' ' -f1 | cut -d'.' -f1`
	if [ $load -ge $MAX_LOAD ]; then
		sleep $SLEEP_DURATION
		continue
	fi
}

# do actual stuffs here
run_task() {
	echo running
	sleep 1
}

main() {
while true; do
	check_stop
	check_pause
	check_load
	run_task
done
}

main
