#!/bin/bash
project='topicScores'
echo "updating EC2 instance..."

ssh-agent bash -c 'ssh-add ~/Downloads/ec2.pem; git push '$project'.com +master:refs/heads/master'
ssh -i ~/Downloads/ec2.pem ubuntu@"$1" sudo python $project/manage.py syncdb
ssh -i ~/Downloads/ec2.pem ubuntu@"$1" sudo service apache2 restart

# eg.
# bash EC2update.sh ec2-54-186-43-74.us-west-2.compute.amazonaws.com
