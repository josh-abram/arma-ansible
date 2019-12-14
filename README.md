# arma-ansible
Ansible Template and Roles for automating the setup of an ARMA 3 Server
Note: Supports Ubuntu 18.04 only

Still very much a work in progress. Currently runs as root user due to permissions issues (you have been warned).

run with: ansible-playbook -i hosts --user arma --ask-pass --become --ask-become-pass armaplaybook.yml
