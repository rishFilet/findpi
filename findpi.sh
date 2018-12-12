command="`ifconfig`"
declare -a ips
while read line
do
  alllines="$line"
  if [[ $line =~ "inet" ]]
  then
    if [[ $line != *"inet6"* ]]
    then
      if [[ $line != *"127"* ]]
      then
        lastline="$line"
        ip="${lastline##*inet}"
        ip="${ip%netmask*}"
        echo ${ip}
        ips+=(${ip})
      fi
    fi
  fi
done <<< "$command"

echo "${ips[0]%.*}"

test="${ips[0]%.*}"
test2=${test}".0/24"
echo ${test2}
echo "Mutantx1" | sudo -S nmap -sP ${test2}
