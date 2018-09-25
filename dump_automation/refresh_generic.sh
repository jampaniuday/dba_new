#!/bin/bash
~/starteam-en-10.4.7-java/bin/stcmd co -p "ohada:ohada@tra-starteam:49201/JPMC/db/inc/generic" -is -stop -cmp  -ts -rp "/home/oracle/upgrade" -filter "MOIGU" -o
dos2unix /home/oracle/upgrade/db/inc/generic/upgrade/upgrade_script.sh

