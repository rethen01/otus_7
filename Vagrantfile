# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

  config.vm.box = "generic/centos8s"
  #config.vm.box = "centos/stream8"
  #config.vm.box_version = "20210210.0"
  config.vm.provision "shell", path: "script.sh"
end
