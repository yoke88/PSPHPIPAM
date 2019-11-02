# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
vagrant_root = File.dirname(__FILE__)

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  # if windows ,using host vm
  # if linux or macos using docker locally
  force_host_vm = true
else
  force_host_vm = true 
end
DEFAULT_MYSQL_ROOT_PASSWORD='my-secret-pw-Oo'
ENV['VAGRANT_DEFAULT_PROVIDER'] = "docker"
Vagrant.configure("2") do |config|
  config.vm.define "mysql" do |mysql|
    mysql.vm.provider "docker" do |d|
      d.image = "mysql:5.6"
      d.name="mysql"
      d.force_host_vm = force_host_vm
      d.vagrant_vagrantfile="./Vagrantfile.host"
      d.env={
        'MYSQL_ROOT_PASSWORD' => DEFAULT_MYSQL_ROOT_PASSWORD
      }
    end
    mysql.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "phpipam" do |phpipam|
    phpipam.vm.provider "docker" do |d|
      d.image = "pierrecdn/phpipam"
      d.name="phpipam"
      d.force_host_vm = force_host_vm
      d.vagrant_vagrantfile="./Vagrantfile.host"
      d.link('mysql:mysql')
      d.env={
        'MYSQL_ROOT_PASSWORD' => DEFAULT_MYSQL_ROOT_PASSWORD
      }
    end
    phpipam.vm.synced_folder ".", "/vagrant", disabled: true
  end
  config.vm.define "nginx" do |nginx|
    nginx.vm.provider "docker" do |d|
      d.image = "nginx:alpine"
      d.name="nginx"
      d.force_host_vm = force_host_vm
      d.vagrant_vagrantfile="./Vagrantfile.host"
      d.link('phpipam:phpipam')
      # phpipam does not support nat well in virtualbox ,so we make the nat port number = nginx listtening port
      # and in linux virtualbox can not listening a port < 1024 ,so we can not using 80,443 as NAT port
      d.ports=['8080:8080','4433:4433']
      
    end
    nginx.vm.synced_folder ".", "/vagrant", disabled: true
    nginx.vm.synced_folder "nginx", "/etc/nginx/conf.d", disabled: false
    # nginx.vm.synced_folder "nginx/log", "/var/log/nginx", disabled: false
    nginx.vm.post_up_message="
  ========================================================================
    config the phpipam env at      : http://127.0.0.1:8080 and https://127.0.0.1:4433
    the default mysql root pass is : #{DEFAULT_MYSQL_ROOT_PASSWORD}
  ========================================================================
    "
  end
end
