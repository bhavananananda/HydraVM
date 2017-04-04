
# Hyrax  : beta  -  https://github.com/projecthydra-labs/hyrax.git
# Solr    : 6.4.2 - http://archive.apache.org/dist/lucene/solr/6.4.1/solr-6.4.1.tgz
# Fedora  : 4.7.1 - https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.7.2/fcrepo-webapp-4.7.2-jetty-console.jar (one click applciation)
# FITS    : 1.0.7 - http://projects.iq.harvard.edu/files/fits/files/fits-1.0.7.zip
# Redis   : 3.2.1
# openjdk : openjdk-8-jre-headless
# Ruby    : 2.3
# Rails   : 5.0.2
# Tomcat  : 7
# Jetty   : 9.4.2 - http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.2.v20170220/jetty-distribution-9.4.2.v20170220.tar.gz



function installing {
    echo installing $1
    shift
    sudo apt-get -y install "$@" >/dev/null 2>&1
}

echo adding swap file
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
sudo apt-get -y update >/dev/null 2>&1

installing 'development tools' build-essential libreadline-dev
installing 'java' openjdk-8-jre-headless
installing 'unzip' unzip
installing 'tomcat' tomcat7

installing 'Ruby' ruby2.3 ruby2.3-dev
update-alternatives --set ruby /usr/bin/ruby2.3 >/dev/null 2>&1
update-alternatives --set gem /usr/bin/gem2.3 >/dev/null 2>&1

echo installing Bundler
gem_install bundler -N >/dev/null 2>&1

installing 'Git' git
installing 'Redis' redis-server

# pry gem for debugging ruby app
#sudo gem install pry 

# Rails
echo installing rails
sudo gem install rails -v 5.0.1


# Fedora
# more information here:https://wiki.duraspace.org/display/FEDORA471/Quick+Start
cd /vagrant/downloads
mkdir fedora
cd /vagrant/downloads/fedora
wget https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-4.7.2/fcrepo-webapp-4.7.2-jetty-console.jar
sudo java -jar fcrepo-webapp-4.7.2-jetty-console.jar &
# AVAILABLE AT:  http://localhost:8080/rest/


# Hyrax app setup
mkdir /vagrant/src
cd /vagrant/src
rails new hyrax_app -m https://raw.githubusercontent.com/projecthydra-labs/hyrax/master/template.rb
cd hyrax_app
rails generate hyrax:work Work


# solr
mkdir /vagrant/downloads
cd /vagrant/downloads
wget  http://archive.apache.org/dist/lucene/solr/6.4.1/solr-6.4.1.tgz
tar zxf solr-6.4.1.tgz
cd /vagrant/downloads/solr-6.4.1
# Creating a new solr core - hydra-development
mkdir /vagrant/downloads/solr-6.4.1/server/solr/hydra-development
cp -R /vagrant/src/hyrax_app/solr/config/* /vagrant/downloads/solr-6.4.1/server/solr/hydra-development/
/vagrant/downloads/solr-6.4.1/bin/solr start
/vagrant/downloads/solr-6.4.1/bin/solr create -c hydra-development
/vagrant/downloads/solr-6.4.1/bin/solr stop
/vagrant/downloads/solr-6.4.1/bin/solr start

# AVAILABLE AT:  http://localhost:8983/solr/


# fits
cd /vagrant/downloads
wget http://projects.iq.harvard.edu/files/fits/files/fits-1.0.7.zip
unzip fits-1.0.7.zip
cd fits-1.0.7
chmod a+x fits.sh
./fits.sh -h

# SQL Lite
installing SQLite libsqlite3-dev

# Postgres
installing PostgreSQL postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser --superuser ubuntu

installing 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev
installing 'Blade dependencies' libncurses5-dev
installing 'ExecJS runtime' nodejs


# Needed for docs generation.
locale-gen "en_GB.UTF-8"
dpkg-reconfigure -f noninteractive locales
update-locale LANG=en_GB.UTF-8 LANGUAGE=en_GB.UTF-8 LC_ALL=en_GB.UTF-8

# Make sure to change the following ports in the hyrax_app yml files
# Fedora : Make sure the port is 8080 for ENV:'Development' in /vagrant/src/hyrax_app.config/fedora.yml 
# Solr : Make sure the port is 8983 for ENV:'Development' in /vagrant/src/hyrax_app.config/fedora.yml


# Hyrax app - Run the app!
cd /vagrant/src/hyrax_app
cp /vagrant/fedora.yml /vagrant/src/hyrax_app/config/fedora.yml


# "Make sure to change the following ports in the hyrax_app yml files"
# "Fedora : Make sure the port is 8080 for ENV:'Development' in /vagrant/src/hyrax_app.config/fedora.yml" 
# "Solr : Make sure the port is 8983 for ENV:'Development' in /vagrant/src/hyrax_app.config/fedora.yml"
# "cd /vagrant/src/hyrax_app"
# "Run this command:"

rake db:setup
rails server -b 0.0.0.0
# AVAILABLE AT: http://localhost:3000 from your host VM!




