#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: runnohosts.sh vm"
    exit 1
fi

name=${1}
brname="br0"
tapname="tap0"
ipaddr="10.0.10"
iprange=${ipaddr}".1/24"
ipbrcst=${ipaddr}".255"
uname2="$(stat --format '%U' "${name}")"

echo -e "\033[01;34m# Setting up bridge ${brname}...\033[0m"
ip link add name ${brname} type bridge
ip addr add ${iprange} broadcast ${ipbrcst} dev ${brname}
ip link set ${brname} up
bridge link

echo -e "\033[01;36m# Setting up TAP ${tapname}...\033[0m"
ip tuntap add dev ${tapname} mode tap
ip link set ${tapname} up promisc on

echo -e "\033[01;32m# Adding ${tapname} to ${brname}...\033[0m"
ip link set ${tapname} master ${brname}

echo -e "\033[01;35m# Running dnsmasq...\033[0m\n"
dnsmasq --interface=${brname} --bind-interfaces --dhcp-range="${ipaddr}.10,${ipaddr}.254"

echo -e "\n\033[01;33m# Running vm ${name}...\033[0m"
su ${uname2} -c "qemu-system-x86_64 -enable-kvm -m 1024 -netdev tap,id=t0,ifname=${tapname},script=no,downscript=no -device e1000,netdev=t0,id=nic0 -nographic ${name}"
echo -e "\033[01;33m# Vm ${name} stopped\033[0m\n"

echo -e "\033[01;32m# Unlinking ${tapname} from ${brname}...\033[0m"
ip link set ${tapname} nomaster
echo -e "\033[01;36m# Deleting TAP ${tapname}...\033[0m"
ip link set ${tapname} down
ip tuntap del ${tapname} mode tap
echo -e "\033[01;34m# Deleting bridge ${brname}...\033[0m"
ip link del ${brname} type bridge
echo -e "\033[01;31m# Killing dnsmasq...\033[0m"
pid=$(ps -ef | grep -e "^nobody.*dnsmasq.*${brname}" | awk '{print $2}')
kill -s 9 ${pid}
