# arma-ansible
Ansible Template and Roles for automating the setup of an ARMA 3 Server
Note: Supports Ubuntu 18.04 only

Still very much a work in progress. Currently runs as root user due to permissions issues (you have been warned).

If you want to run entirely by command line without editing the defaults or hosts files you can do this (replace xxx.xxx.xxx.xx with your IP: 

run with: ansible-playbook -i xxx.xxx.xxx.xx --user arma --ask-pass --become --ask-become-pass armaplaybook.yml -e "steam_username=username steam_password=password"

otherwise: ansible-playbook -i hosts --user arma --ask-pass --become --ask-become-pass armaplaybook.yml
