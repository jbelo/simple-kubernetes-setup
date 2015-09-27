# vi: set ft=ruby :

# Note: by default, the VM's first nat interface, eth0 for
# vagrant machines, is assigned the ip 10.0.2.15. This follows
# the pattern 10.0.x.15, where x is the interface number, 0 in
# vagrant's case, plus two.
# Therefore, we consider the cidr range 10.0/16 reserved.

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "debian/jessie64"
  config.vm.synced_folder ".", "/vagrant"
  #config.vm.synced_folder ".", "/vagrant", :mount_options => ['dmode=775', 'fmode=775']
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--nic3", "intnet"]
    v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
  end

  # Setup master
  config.vm.define "kube-master" do |node|
    node.vm.hostname = "kube-master"
    node.vm.network :private_network, ip: "10.1.0.10"
    config.vm.provision :file, source: "requirements.yml", destination: "requirements.yml"
    node.vm.provision :shell, privileged: true, inline: <<-SHELL
      apt-get update
      apt-get install --yes python-pip python-dev
      pip install ansible
      ansible-galaxy install -r requirements.yml
    SHELL
  end

  # Setup nodes
  (1..3).each do |i|
    config.vm.define "kube-node-0#{i}" do |node|
      node.vm.hostname = "kube-node-0#{i}"
      node.vm.network :private_network, ip: "10.1.0.1#{i}"
      node.vm.provision :shell, privileged: true, inline: <<-SHELL
        apt-get update
      SHELL
    end
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
end
