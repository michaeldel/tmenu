#!/usr/bin/env bash
pipe=$(mktemp -u)
parent=$(xwininfo -root | sed -nr 's/.*Window id: (0x[^ ]+).*/\1/p')
h=256

mkfifo -m 600 $pipe || exit 1

alacritty -e sh -c "${@} > ${pipe} < /proc/$$/fd/0" &
pid=$!
trap "kill $pid" SIGINT SIGHUP SIGTERM

sleep 0.1
xdotool search --all --pid $pid --class '.*' \
    set_window --overrideredirect 1 \
    windowreparent $parent \
    windowmove --sync 0 0 \
    windowsize --sync 100% $h 

wid=$(xdotool search --all --pid $pid --class '.*')
# focus grab has to be forced
for _ in {1..100}; do
    xdotool search --all --pid $pid --class '.*' windowfocus --sync 2> /dev/null && break
done

[ "$(xdotool getwindowfocus -f)" = "$wid" ] || {
    echo 'failed to focus' >&2 && \
    kill $pid && \
    rm $pipe && \
    exit 1
}

cat $pipe
rm $pipe
# TODO: fix original window focus lost after done

