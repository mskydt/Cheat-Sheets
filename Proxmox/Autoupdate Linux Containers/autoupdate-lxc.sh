############################ DRAFT - UNFINISHED ############################
#!/bin/bash
# update all containers

# list of container ids we need to iterate through
#ORIGINAL# containers=$(/usr/sbin/pct list | tail -n +2 | cut -f1 -d' ')
containers=$(cat lxc.list)
skiplist=$(cat lxcskip.list)

function update_container() {
  container=$1
  echo "[Info] Updating $container"
  # to chain commands within one exec we will need to wrap them in bash
  #ORIGINAL# /usr/sbin/pct exec $container -- bash -c "apt update && apt upgrade -y && apt autoremove -y"
}


for container in $containers
do
    if [[ ! " ${skiplist[*]} " =~ " $container " ]]; then
        # whatever you want to do when array doesn't contain value
        echo [Info] Container $container skipped
    else
        update_container $container
    fi
done; wait



# for container in $containers
# do
    # if [ $container = "200" ]; then
        # echo [Info] Container 200 found
    # else
        # update_container $container
    # fi
# done; wait


#ORIGINAL# for container in $containers
#ORIGINAL# do
  #ORIGINAL# status=`/usr/sbin/pct status $container`
  #ORIGINAL# if [ "$status" == "status: stopped" ]; then
    #ORIGINAL# echo [Info] Starting $container
    #ORIGINAL# /usr/sbin/pct start $container
    #ORIGINAL# echo [Info] Sleeping 5 seconds
    #ORIGINAL# sleep 5
    #ORIGINAL# update_container $container
    #ORIGINAL# echo [Info] Shutting down $container
    #ORIGINAL# /usr/sbin/pct shutdown $container &
  #ORIGINAL# elif [ "$status" == "status: running" ]; then
    #ORIGINAL# update_container $container
  #ORIGINAL# fi
#ORIGINAL# done; wait