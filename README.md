# mysql

Script for checking the mysql replication status on Slave database.

The following variables can be personalized :

  - Database server to check the slave status : 

      DBHOST=localhost

  - Email address to send the notification when the replication is not working :

      EMAIL_ADDRESS="deep.raman85@gmail.com"


In this case the connection from localhost doesn't require mysql user and password but you may require these parameters to access your database.

