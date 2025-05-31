# -*- mode: ruby -*-
# vi: set ft=ruby :

#-----------------------------------------------------------------------------------------------------------------------------------------
# Leader Node
lnode_vm_name = "leader-node"                      
lnode_box_name = "ubuntu/focal64"                          
lnode_cpus = 1                                            
lnode_memory = 1024                                       
lnode_disk_size = "40GB"                                  
lnode_provisioning_script = "./provisioning/provision_lnode.sh"   
lnode_hostname = "leader-node"                             
lnode_private_ip = "192.168.65.10"                        

#-----------------------------------------------------------------------------------------------------------------------------------------
# Manager Nodes
mnode_box_name = "ubuntu/focal64"                          
mnode_cpus = 1                                            
mnode_memory = 1024                                       
mnode_disk_size = "40GB"                                  
mnode_provisioning_script = "./provisioning/provision_mnode.sh" 

mnode_vms = [
  { 
    name: "mnode1",                                    
    hostname: "mnode1",                                
    ip: "192.168.65.11",                                 
  },
  # { 
  #   name: "mnode2",                                    
  #   hostname: "mnode2",                                
  #   ip: "192.168.65.12",                                 
  # },
]
#-----------------------------------------------------------------------------------------------------------------------------------------
# Worker Nodes
wnode_box_name = "ubuntu/focal64"                          
wnode_cpus = 1                                            
wnode_memory = 1024                                       
wnode_disk_size = "40GB"                                  
wnode_provisioning_script = "./provisioning/provision_wnode.sh" 

wnode_vms = [
  { 
    name: "wnode1",                                    
    hostname: "wnode1",                                
    ip: "192.168.65.13",                                 
  },
  # { 
  #   name: "wnode2",                                    
  #   hostname: "wnode2",                                
  #   ip: "192.168.65.14",                                 
  # },
]
#-----------------------------------------------------------------------------------------------------------------------------------------

Vagrant.configure("2") do |config|

  # Leader Node Vm Settings
  config.vm.define lnode_vm_name do |lnode|
    lnode.vm.provider "virtualbox" do |vb|
      vb.name = lnode_vm_name
      # Optional: Uncomment to explicitly set CPU and memory
      # vb.cpus = lnode_cpus
      # vb.memory = lnode_memory
    end
    lnode.vm.box = lnode_box_name
    lnode.vm.disk :disk, size: lnode_disk_size, primary: true
    lnode.vm.hostname = lnode_hostname
    lnode.vm.network "private_network", ip: lnode_private_ip
    lnode.vm.provision "shell", path: lnode_provisioning_script,
      env: { 
        "LEADER_NODE_IP" => lnode_private_ip 
      }
  end

  # Manager Nodes Vm Settings
  mnode_vms.each do |vm_config|
    config.vm.define vm_config[:name] do |mnode|
      mnode.vm.provider "virtualbox" do |vb|
        vb.name = vm_config[:name]
      # Optional: Uncomment to explicitly set CPU and memory
        # vb.cpus = node_cpus
        # vb.memory = node_memory
      end
      mnode.vm.box = mnode_box_name
      mnode.vm.hostname = vm_config[:hostname]
      mnode.vm.network "private_network", ip: vm_config[:ip]
      mnode.vm.disk :disk, size: mnode_disk_size, primary: true
      # Wait for leader to be provisioned first
      mnode.vm.provision "wait-for-leader-node", type: "shell", run: "always", inline: <<-SHELL
        while [ ! -f /vagrant/secrets/manager_token ]; do sleep 1; done
      SHELL
      mnode.vm.provision "shell", path: mnode_provisioning_script
    end
  end

  # Worker Nodes Vm Settings
  wnode_vms.each do |vm_config|
    config.vm.define vm_config[:name] do |wnode|
      wnode.vm.provider "virtualbox" do |vb|
        vb.name = vm_config[:name]
      # Optional: Uncomment to explicitly set CPU and memory
        # vb.cpus = node_cpus
        # vb.memory = node_memory
      end
      wnode.vm.box = wnode_box_name
      wnode.vm.hostname = vm_config[:hostname]
      wnode.vm.network "private_network", ip: vm_config[:ip]
      wnode.vm.disk :disk, size: wnode_disk_size, primary: true
      # Wait for leader to be provisioned first
      wnode.vm.provision "wait-for-leader-node", type: "shell", run: "always", inline: <<-SHELL
        while [ ! -f /vagrant/secrets/worker_token ]; do sleep 1; done
      SHELL
      wnode.vm.provision "shell", path: wnode_provisioning_script
    end
  end
end
