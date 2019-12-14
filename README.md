# arma-ansible
Ansible Template and Roles for automating the setup of an ARMA 3 Server

prereqs: assumes target machine (arma server) is running Ubuntu 18.04

run with: ansible-playbook -i hosts --user arma --ask-pass --become --ask-become-pass armaplaybook.yml
