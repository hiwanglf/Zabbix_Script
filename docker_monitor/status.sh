#! /bin/bash

# by lengtoo 
# date 2017 6 26
function docker_service() {
## 1= has docker process
## 0= no docker process
if 
sudo systemctl status docker | grep "active (running)">>/dev/null
then
    echo "1"

else 
    echo "0"
fi

}
STATUS="docker_service";
$STATUS
