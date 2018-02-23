# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  # if windows ,using host vm
  # if linux or macos using docker locally
  force_host_vm = true
else
  force_host_vm = false 
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
      d.ports=['80:80']
    end
    phpipam.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.post_up_message="
  ========================================================================
    config the phpipam env at      : http://127.0.0.1/
    the default mysql root pass is : my-secret-pw-Oo
  ========================================================================
    "
end