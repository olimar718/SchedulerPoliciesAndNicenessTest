#!/bin/bash
frequency=1.7
NormalFrequency=2.7
# resultfile="result_niceness_increase_other.txt"
resultfile="result_fifo_idle"


time_to_s(){
  executiontime=$1
  calcstring="$(echo $executiontime | grep -Eo '[0-9]{1,3}m' | grep -Eo '[0-9]')"
  calc=' * 60' # one minute is 60 seconds
  calcstring=$calcstring$calc
  seconds_standart_executiontime="$(bc <<< $calcstring) + $(echo $executiontime | grep -Eo '[0-9]{1,2}.[0-9]{3}')"
  seconds_standart_executiontime=$(bc <<< $seconds_standart_executiontime)
  echo $seconds_standart_executiontime
}



sudo cpupower frequency-set --max $frequency\GHz > /dev/null

timereturn=$({ time ./increment >/dev/null; } |&  grep -E real | grep -Eo "[0-9]{1}m[0-9]{1,2}.[0-9]{3}")

seconds_standart_executiontime=$(time_to_s \'$timereturn\')
echo $seconds_standart_executiontime


echo ""> $resultfile

sudo echo
stress -c 4 & #loading the system massively with stresses (4 because I have a 4 core processor)
for pid in $(pidof stress)
do
sudo chrt --idle -p 0 $pid
  # :
done







commandbatch='sudo chrt --batch -p 0 $BASHPID
time ./increment'

commanddeadline='sudo chrt --deadline -p 99 $BASHPID
time ./increment'

#
# # RR loop
# for staticpriority in $(seq 1 99);
# do
#   commandrr='sudo chrt --rr -p '$staticpriority' $BASHPID
#   { time ./increment >/dev/null; } |&  grep -E real | grep -Eo "[0-9]{1}m[0-9]{1,2}.[0-9]{3}"'
#   result=$(bash <<< $commandrr)  #new bash session to avoid setting realtime stresses which would block the system
#   second=$(time_to_s \'$result\')
#   ratio=$(bc -l <<< "$second / $seconds_standart_executiontime")
#   echo $ratio >> $resultfile
# done

# FIFO loop
for staticpriority in $(seq 1 99);
do
  commandfifo='sudo chrt --fifo -p '$staticpriority' $BASHPID
  { time ./increment >/dev/null; } |&  grep -E real | grep -Eo "[0-9]{1}m[0-9]{1,2}.[0-9]{3}"'
  result=$(bash <<< $commandfifo)  #new bash session to avoid setting realtime stresses which would block the system
  second=$(time_to_s \'$result\')
  ratio=$(bc -l <<< "$second / $seconds_standart_executiontime")
  echo $ratio >> $resultfile
done

## Other LOOP
# for niceness in `seq -19 20`;
# do
#   commandother='sudo chrt --other -p 0 $BASHPID
#   sudo renice --priority '$niceness' --pid $BASHPID > /dev/null
#   { time ./increment >/dev/null; } |&  grep -E real | grep -Eo "[0-9]{1}m[0-9]{1,2}.[0-9]{3}"'
#   result=$(bash <<< $commandother)  #new bash session to avoid setting realtime stresses which would block the system
#   second=$(time_to_s \'$result\')
#   ratio=$(bc -l <<< "$second / $seconds_standart_executiontime")
#   echo $ratio >> $resultfile
# done


killall stress # removing stresses so that your computer doesn't become a airplane
sudo cpupower frequency-set --max $NormalFrequency\GHz > /dev/null
