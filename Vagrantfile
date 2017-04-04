# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/yakkety64'
  config.vm.hostname = 'HyraxVM'
  config.vm.network 'forwarded_port', guest: 3000, host: 8000
  config.vm.network 'forwarded_port', guest: 15_673, host: 15_673
  config.vm.network 'forwarded_port', guest: 8983, host: 8983
  config.vm.network 'forwarded_port', guest: 8080, host: 8080

  config.vm.provision :shell, path: 'bootstrap.sh', keep_color: true
  config.vm.synced_folder '/home/zool09892/Desktop/MyDesktopBhavana/git/HyraxVM', '/vagrant'

  config.vm.provider 'virtualbox' do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end
end
