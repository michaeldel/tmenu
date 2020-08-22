#!/usr/bin/env bash
POSITIONAL=()

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -w)
            parent="$2"
            shift
            shift
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done
set -- "${POSITIONAL[@]}"

pipe=$(mktemp -u)
parent=${parent:-$(xwininfo -root | sed -nr 's/.*Window id: (0x[^ ]+).*/\1/p')}
h=256

mkfifo -m 600 $pipe || exit 1

command="${@} > ${pipe} < /proc/$$/fd/0"
alacritty -e sh -c "$command" &
pid=$!
trap "kill $pid" SIGINT SIGHUP SIGTERM

sleep 0.1
xdotool search --all --pid $pid --class '.*' \
    set_window --overrideredirect 1 \
    windowreparent $parent \
    windowsize --sync 100% $h \
    windowmove --sync 0 0 \
    windowmap --sync

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

