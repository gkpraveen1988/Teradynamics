#!/bin/bash
nfsMount='/backup_scripts/s3_data'
log_file='/tmp/dailyStatusLog.txt'
aws_s3_bucket='terascripts123'
date_stmp=`date +%D-%T`
export AWS_ACCESS_KEY_ID='XXX'
export AWS_SECRET_ACCESS_KEY='XXX'

# To check for the log files is present
[ -f "$log_file" ] && echo "" || touch "$log_file"

echo "$date_stmp--- Starting execution of the scripts" >> $log_file
echo "$date_stmp--- Checking for the NFS Drive is mounted" >> $log_file

# To check whether the ISCSI mount point is available
mount_stat=`df $nfsMount | grep -v "^Filesystem"| wc -l`
if [[ $mount_stat -gt 0 ]]
then
 echo "$date_stmp--- NFS Drive Mount available" >> $log_file
 echo "$date_stmp--- Trying connect to S3 bucket" >> $log_file
  aws_s3_check=$(aws s3 ls s3://$aws_s3_bucket 2>&1| grep -w 'Backup_files' | wc -l)
  if [[ $aws_s3_check -gt 0 ]];then 
   echo "$date_stmp--- S3 Bucket available" >> $log_file
   aws s3 sync s3://$aws_s3_bucket/Backup_files $nfsMount 2>&1 >> /dev/null
   echo "$date_stmp--- Syncing done to the NFS drive" >> $log_file
  else echo "$date_stmp--- S3 bucket not availabe to S3 bucket" >> $log_file
   exit 0
  fi
else
 echo "$date_stmp--- NFS Drive Mount NOT available,Exiting execution....." >> $log_file
fi







