#!/bin/bash

##########################################################################################################
#
#  Author        :  Raman Deep
#  Email         :  raman@sky-tours.com
#  Date          :  14 Nov 2018
#  Description   :  Script for checking the MySql Slave replication status. 
#  Version       :  1.0
#
##########################################################################################################

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
HOSTNAME=$(hostname)
DBHOST=localhost
EMAIL_ADDRESS="raman@sky-tours.com"
EMAIL_SUBJECT="$HOSTNAME : MySQL Slave Replication error"

# Check slave status executing the show slave status in mysql
SLAVE_STATUS=$(mysql -e 'show slave status\G' | grep Slave_SQL_Running | grep -v State |awk '{print $2}')

if [[ "$SLAVE_STATUS" == "No" ]]; then
    MSG=$(mysql -h $DBHOST -e 'show slave status\G' | grep Last_SQL_Error | grep -v Timestamp | sed -e 's/ *Last_SQL_Error: //')
    MSG="Coordinator stopped because there were error(s) in the worker(s). The most recent failure being: Worker 5 failed executing transaction 'ANONYMOUS' at master log mysql_bin.015433, end_log_pos 51855815. See error log and/or performance_schema.replication_applier_status_by_worker table for more details about this failure or others, if any. Last_SQL_Error_Timestamp: 181114 10:01:07"
    if [ -n "$MSG" ]; then
        TIMESTAMP=$(mysql -h $DBHOST -e 'show slave status\G' | grep Last_SQL_Error_Timestamp)
        TIMESTAMP="Last_SQL_Error_Timestamp: 181114 10:01:07"
        # email someone
        printf "%s \n %s" "$MSG" "$TIMESTAMP" | mailx -s "$EMAIL_SUBJECT" $EMAIL_ADDRESS
    else
        MSG="Please check the mysql replication status on slave $HOSTNAME"
        printf "%s \n %s" "$MSG" "$TIMESTAMP" | mailx -s "$EMAIL_SUBJECT" $EMAIL_ADDRESS

    fi
fi
