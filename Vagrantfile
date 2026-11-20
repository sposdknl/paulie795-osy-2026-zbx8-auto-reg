IMAGE_NAME = "bento/debian-13"

Vagrant.configure("2") do |config|
  config.vm.define "debian-zabbix" do |vm|
    vm.vm.box = IMAGE_NAME
    vm.vm.hostname = "debian-zabbix"
    vm.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

    vm.vm.provider "virtualbox" do |vb|
      vb.name = "spos-debian-zabbix-podzimek"
      vb.memory = 1024
      vb.cpus = 1
    end

    vm.vm.provision "shell", path: "install-tools.sh"
    vm.vm.provision "shell", path: "install-zabbix8-agent2.sh"
    vm.vm.provision "shell", path: "configure-zabbix8-agent2.sh"
  end
end
