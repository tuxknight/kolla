Kolla with Ansible!
============================

Kolla supports deploying Openstack using [Ansible][].

[Ansible]: https://docs.ansible.com


Getting Started
---------------

To run the Ansible playbooks, an inventory file which tracks all of the
available nodes in the environment must be speficied. With this inventory file
Ansible will log into each node via ssh (configurable) and run tasks. Ansible
does not require password-less logins via ssh, however it is highly recommended
to setup ssh-keys.

Two sample inventory files are provided, *all-in-one*, and *multinode*. The
"all-in-one" inventory defaults to use the Ansible "local" connection type,
which removes the need to setup ssh keys in order to get started quickly.

More information on the Ansible inventory file can be found [here][].

[here]: https://docs.ansible.com/intro_inventory.html

Deploying
---------

Add the etc/kolla directory to /etc/kolla on the deployment host. Inside of
this directory are two files and a minimum number of parameters which are
listed below.

All variables for the environment can be specified in the files:
"/etc/kolla/globals.yml" and "/etc/kolla/passwords.yml"

    kolla_external_address: "openstack.example.com"
    kolla_internal_address: "10.10.10.254"

The kolla_*_address variables can both be the same. When the keepalived and
haproxy containers are implemented in Ansible this will be a VIP. While waiting
for completion of the services, just use the ip address of one of the nodes
running the services.

    network_interface: "eth0"

The network_interface is what will be given to neutron to use. It should not
have an ip on the interface.

    docker_pull_policy: "always"

The docker_pull_policy specifies whether Docker should always pull images from
Docker Hub, or only in the case where the image isn't present locally. If you
are building your own images locally without pushing them to the Docker
Registry, or a local registry, you will want to set this value to "missing".

For All-In-One deploys, the following commands can be run. These will setup all
of the containers on the localhost. These commands will be wrapped in the
kolla-script in the future.

    cd ./kolla/ansible
    ansible-playbook -i inventory/all-in-one -e @/etc/kolla/defaults.yml -e @/etc/kolla/globals.yml -e @/etc/kolla/passwords.yml site.yml

To run the playbooks for only a particular service, Ansible tags can be used.
Multiple tags may be specified, and order is still determined by the playbooks.

    cd ./kolla/ansible
    ansible-playbook -i inventory/all-in-one -e @/etc/kolla/defaults.yml -e @/etc/kolla/globals.yml -e @/etc/kolla/passwords.yml site.yml --tags message-broker
    ansible-playbook -i inventory/all-in-one -e @/etc/kolla/defaults.yml -e @/etc/kolla/globals.yml -e @/etc/kolla/passwords.yml site.yml --tags message-broker,database


Further Reading
---------------

Ansible playbook documentation can be found [here][].

[here]: http://docs.ansible.com/playbooks.html
