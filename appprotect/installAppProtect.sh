#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${RED}##make sure you have the zip in the same dir as the script##"
echo -e "##the OS have to be centOS 7.4.x ##"
echo -e "##make sure you run the script with sudo##${NC}"

[[ $(id -u) -eq 0 ]] || { echo >&2 "Must be root to run script"; exit 1; }

if [[ $# -eq 0 ]] ; then
    echo 'error : no zip file provided'
    exit 0
fi

CUR_VER=$(rpm -qa | grep nginx-plus-1 |grep -Po  '(?<=(nginx-plus-)).*(?=-)')
NUMBER=$(echo "$1" | sed 's/[^0-9]*//g')
#check nginx veriosn

if [ -n "$CUR_VER" ] && [ "$CUR_VER" != "$NUMBER" ] ; then
    echo "error : nginx veriosn is $CUR_VER and zip veriosn is $NUMBER"
    exit 0
fi

yum install epel-release unzip -y

#check veriosn and install by version

mkdir r$NUMBER
unzip $1 -d r${NUMBER}
cd r${NUMBER}\

yum install -y openssl
yum install -y f5*
yum install -y nginx-plus-${NUMBER}*
yum install -y app-protect-plugin-*
yum install -y app-protect-compiler-*.x86_64.rpm
yum install -y app-protect-engine-*.el7.centos.x86_64.rpm
yum install -y nginx-plus-module-appprotect-${NUMBER}*
yum install -y app-protect-${NUMBER}*

cd -
if [[ $(rpm -qa | grep app-protect-${NUMBER}) ]]; then
    echo -e "${GREEN}###install done, please configure nginx.conf###${NC}"
else
    echo -e "${RED}###failed to install, see above output ###${NC}"
fi

#######run with:
#/bin/su -s /bin/bash -c '/opt/f5waf/bin/bd_agent &' nginx
#/bin/su -s /bin/bash -c "/usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config 2>&1 > /var/log/f5waf/bd-socket-plugin.log &" nginx
#/usr/sbin/nginx
