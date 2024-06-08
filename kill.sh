ps -eo pid,COMMAND | grep /ab.sh | awk '{print $1}'>./process.txt
while read process <./process.txt;
do
ps -eo pid,COMMAND | grep /ab.sh | awk '{print $1}'>./process.txt
echo $process
kill -9 $process
done
echo 1