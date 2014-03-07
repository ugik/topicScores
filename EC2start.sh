#!/bin/bash
#
# instantiate EC2 Ubuntu Server 12.04.3 LTS - ami-6aad335a (64-bit)
# save ssh key to ~/Downloads as ec2.pem
# mysqldump -u root -p[root_password] [database_name] > data.sql
#
echo "copying to EC2 instance..."
echo 'setup script'
scp -i ~/Downloads/ec2.pem EC2setupSimple.sh ubuntu@"$1":EC2setupSimple.sh
ssh -i ~/Downloads/ec2.pem ubuntu@"$1" bash EC2setupSimple.sh

# eg.
# bash EC2start.sh ec2-54-186-43-74.us-west-2.compute.amazonaws.com
# ssh -i ~/Downloads/ec2.pem ubuntu@ec2-54-186-43-74.us-west-2.compute.amazonaws.com
# scp -i ~/Downloads/ec2.pem foo.file ubuntu@ec2-54-186-43-74.us-west-2.compute.amazonaws.com

