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
    if [ -n "$MSG" ]; then
        TIMESTAMP=$(mysql -h $DBHOST -e 'show slave status\G' | grep Last_SQL_Error_Timestamp)
        # Send email
        printf "%s \n %s" "$MSG" "$TIMESTAMP" | mailx -s "$EMAIL_SUBJECT" $EMAIL_ADDRESS
    else
        MSG="Please check the mysql replication status on slave $HOSTNAME"
        printf "%s \n %s" "$MSG" "$TIMESTAMP" | mailx -s "$EMAIL_SUBJECT" $EMAIL_ADDRESS

    fi
fi
