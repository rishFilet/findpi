command="`ifconfig`"
echo "Executing ifconfig command to gather connected ips...."
declare -a ips
while read line
do
  #alllines="$line"
  if [[ $line =~ "inet" ]]
  then
    if [[ $line != *"inet6"* ]]
    then
      if [[ $line != *"127"* ]]
      then
        lastline="$line"
        ip="${lastline##*inet}"
        ip="${ip%netmask*}"
        #echo ${ip}
        ip="${ip%.*}"
        ips+=(${ip})
      fi
    fi
  fi
done <<< "$command"


declare -a raspips
echo "Gathering ip addresses using nmap.."
for ip in "${ips[@]}"
do
  command="`echo "Mutantx1" | sudo -S nmap -sP ${ip}".0/24"`"
  while read line
  do
    if [[ $line =~ "Nmap scan report" ]]
    then
      ipline="${line##*for}"
    fi
    if [[ $line =~ "Raspberry Pi" ]]
    then
      raspips+=(${ipline})
    fi
  done <<< "$command"
done

for ip in "${raspips[@]}"
do
  #command="`ssh -tt pi@${ip}`"
  ttab ssh -tt pi@${ip}
  while read line
  do
    if [[ $line =~ "Are you sure you want to continue connecting" ]]
    then
      echo "yes"
    fi
    if [[ $line =~ "pi@" ]]
    then
      echo "raspberry"
    fi
  done <<< "$command"
done
