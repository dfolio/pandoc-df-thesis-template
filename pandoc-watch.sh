#!/bin/bash

FORMAT=${1:-'ehtm'}
shift
INPUT=${*:-'md/'}
INOT_OPTS="-rq"

trap ctrl_c INT

function ctrl_c() {
	echo "ctrl_c: $*"
	exit 0;
}
function msg() {
	 GOOD="$(tput sgr0)$(tput bold)$(tput setaf 2)"
	 NORMAL="$(tput sgr0)"
	 TMT=`date +"*** %F %T"`
	 printf " ${GOOD}*[${TMT}]${NORMAL} $*"
	 return 0

}
#echo  "[FORMAT] INPUT ${INPUT}"
#exit 0
#make $FORMAT

while  true; do
  #sleep 0.2
	make $FORMAT ;
	msg  "Watching ${INPUT} ..."
	inotifywait $INOT_OPTS -e MODIFY -e CREATE -e MOVE -e CLOSE_WRITE ${INPUT}
	msg "inotifywait '$*' '$!'"
done
