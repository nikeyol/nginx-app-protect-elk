#!/bin/bash
 
/bin/su -s /bin/bash -c '/opt/f5waf/bin/bd_agent &' nginx
 
/bin/su -s /bin/bash -c "/usr/share/ts/bin/bd-socket-plugin tmm_count 4 proc_cpuinfo_cpu_mhz 2000000 total_xml_memory 307200000 total_umu_max_size 3129344 sys_max_account_id 1024 no_static_config 2>&1 > /var/log/f5waf/bd-socket-plugin.log &" nginx
 
exec /usr/sbin/nginx -g 'daemon off;'
