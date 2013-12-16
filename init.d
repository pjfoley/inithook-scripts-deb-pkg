#!/bin/sh
# Copyright (c) 2009 Alon Swartz <alon@turnkeylinux.org>
#           (c) 2013 Peter Foley <peter@ifoley.id.au>

### BEGIN INIT INFO
# Provides:          inithook-scripts
# Required-Start:    $network $local_fs $remote_fs $named
# Required-Stop:     $network $local_fs $remote_fs $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Executes initialization hooks at boot time
# Description:       Executres first and everyboot scripts
### END INIT INFO


# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin

DESC="Initialization hooks"
NAME=inithook-scripts

# Check if VT's are supported
fgconsole >/dev/null 2>&1 && INITHOOKS_CHVT=y
dpkg -s console-tools >/dev/null 2>&1 && OPENVT_EXTRA_OPTS="-b"

. /lib/lsb/init-functions
. /etc/default/inithook-scripts

case "$1" in
  start)
    log_begin_msg "Starting $DESC"
    if [ "$INITHOOKS_CHVT" ]; then
        setterm -blank 0
        chvt 1
        openvt -c 8 -s -w $OPENVT_EXTRA_OPTS -- $INITHOOKS_PATH/bin/run
    else
        $INITHOOKS_PATH/bin/run
    fi
    log_action_end_msg $?
    ;;

  stop)
    exit 0
    ;;

  restart|reload|force-reload)
    echo "Error: argument '$1' not supported" >&2
    exit 3
    ;;

  *)
    N=/etc/init.d/$NAME
    echo "Usage: $N {start}" >&2
    exit 1
    ;;
esac

exit 0
