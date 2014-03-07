#!/bin/bash
echo "setup EC2 instance..."

repo='ugik'
project='topicScores'
project_app=$project"/topicScores"

# update Ubuntu instance: Ubuntu Server 12.04.3 LTS - ami-6aad335a (64-bit)
sudo apt-get -y update
sudo apt-get -y upgrade

# setup .AMP elements
sudo apt-get -y install apache2 libapache2-mod-wsgi
sudo apt-get -y install python-pip
sudo pip install django
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password mysql'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mysql'
sudo pip install django-tastypie
sudo apt-get -y install mysql-server python-mysqldb
sudo apt-get -y install git-core

# get project files from repo
git clone https://github.com/$repo/$project.git

# connect Apache config to Django project
sudo rm /etc/apache2/httpd.conf
sudo touch /etc/apache2/httpd.conf
sudo chmod 777 /etc/apache2/*.conf
sudo echo "Alias /static /home/ubuntu/django_test/static" >> /etc/apache2/httpd.conf
sudo echo "WSGIScriptAlias / /home/ubuntu/"$project_app"/wsgi.py" >> /etc/apache2/httpd.conf
sudo echo "WSGIPythonPath /home/ubuntu/"$project >> /etc/apache2/httpd.conf
sudo echo "<Directory /home/ubuntu/"$project_app">" >> /etc/apache2/httpd.conf
sudo echo "<Files wsgi.py>" >> /etc/apache2/httpd.conf
sudo echo "    Order deny,allow" >> /etc/apache2/httpd.conf
sudo echo "    Allow from all" >> /etc/apache2/httpd.conf
sudo echo "</Files>" >> /etc/apache2/httpd.conf
sudo echo "</Directory>" >> /etc/apache2/httpd.conf
sudo echo " " >> /etc/apache2/httpd.conf

# set permissions for static files
sudo echo "<Directory /home/ubuntu/"$project"/static>" >> /etc/apache2/httpd.conf
sudo echo "<Files wsgi.py>" >> /etc/apache2/httpd.conf
sudo echo "    Order deny,allow" >> /etc/apache2/httpd.conf
sudo echo "    Allow from all" >> /etc/apache2/httpd.conf
sudo echo "</Files>" >> /etc/apache2/httpd.conf
sudo echo "</Directory>" >> /etc/apache2/httpd.conf

sudo echo "Include httpd.conf" >> /etc/apache2/apache2.conf

# copy django admin statics files
cp -r /usr/local/lib/python2.7/dist-packages/django/contrib/admin/static/ /home/ubuntu/$project/static

# assumes data.sql for data upload
cd ~
mysql -u root -pmysql -e "create database data; GRANT ALL PRIVILEGES ON data.* TO django@localhost IDENTIFIED BY 'django'"
mysql -u root -pmysql data < data.sql

sudo service apache2 restart

# setup remote git repo and hooks
mkdir $project.com.git
cd $project.com.git
git init --bare
cd hooks
sudo echo "#!/bin/sh" >> post-receive
sudo echo "GIT_WORK_TREE=/home/username/public_html/"$project".com/" >> post-receive
sudo echo "export GIT_WORK_TREE" >> post-receive
sudo echo "git checkout -f" >> post-receive
chmod +x post-receive
cd ~

# references:
# remote LAMP setup: http://nickpolet.com/blog/1/
# locale LAMP setup: http://www.lleess.com/2013/05/install-django-on-apache-server-with.html#.UwavkDddV38
# http://cuppster.com/2011/01/30/using-git-to-remotely-install-website-updates/

