#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$TIMESTAMP-$SCRIPT_NAME.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="e[0m"

VALIDATE(){

    If ( $1 -ne 0 )
    then 
        echo -e "$2..$R FAILURE $N"
    else 
        echo -e "$2..$G SUCCESS $N"    
    fi    
}


if [ $USERID -ne 0 ]
  then
       echo "Please run with root user"
  else 
      echo "You are a superuser"
  fi 


  dnf install mysql-server -y &>>$LOGFILE
  VALIDATE $? "Installing MySQL" 

  systemctl enable mysqld &>>$LOGFILE
  VALIDATE $? "Enabling MySql" 

  systemctl start mysqld &>>$LOGFILE 
  VALIDATE $? "Starting MySql"

  mysql -h db.daws78s.online -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE
   if [ $? -eq 0 ]
    then 
         mysql_secure_installation --set-root-pass ExpenseApp@1  &>>$LOGFILE 
         VALIDATE  $? "SettingUp Root Password"
    else 
         echo "MySql Root Password is already setup..$Y SKIPPING $N" 
    fi          
