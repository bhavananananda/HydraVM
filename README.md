Vagrant Hyrax box
=================

Get a Hyrax environment quickly up and running in a VM.

Before you start:

Clone the repository to your desktop: /home/[USER]/git/HyraxVM

Vagrantfile changes:

Ensure to change the directory path to point to the directorypath, the repository is cloned in .

```bash
   config.vm.synced_folder '/home/[USER]/git/HyraxVM', '/vagrant'
```

Running the box:

    1. Install Vagrant
    2. Run these commands:
            cd /home/[USER]/git/HyraxVM
            vagrant up
    3. Solr      : Open http://localhost:8983 (on host)
    4. FEDORA    : Open http://localhost:8080 (on host)
    5. Hyrax app : Open http://localhost:8000 (on host)
    6. vagrant ssh to gain entry into the virtualbox ( does not take username/password)


Troubleshooting:



```bash
Start:
    cd /vagrant/downloads/fedora
    sudo java -jar fcrepo-webapp-4.7.2-jetty-console.jar &

Stop:
    sudo kill -9 $(ps -aux | grep 'fcrepo-webapp-4.7.2-jetty-console'| fgrep -v grep | awk '{ print $2 }')
```

Solr:

```bash
    Start: /vagrant/downloads/solr-6.4.1/bin/solr start
    Stop : /vagrant/downloads/solr-6.4.1/bin/solr stop
```

Hyrax app:

```bash
Start:
    cd /vagrant/src/hyrax_app
    rails server -b 0.0.0.0

Stop:
    CTRL+C to exit
```
