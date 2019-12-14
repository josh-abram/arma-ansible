# arma-automation

![arma-automation-logo](https://puu.sh/EPniq/c906edd668.png)

Ansible Template and Roles for automating the setup of an ARMA 3 Server
Note: Supports Ubuntu 18.04 only

Still very much a work in progress. Currently runs as root user due to permissions issues (you have been warned).

If you want to run entirely by command line without editing the defaults or hosts files you can do this:

run with: ansible-playbook -i hosts --user arma --ask-pass --become --ask-become-pass armaplaybook.yml -e "steam_username=username steam_password=password"

otherwise: ansible-playbook -i hosts --user arma --ask-pass --become --ask-become-pass armaplaybook.yml
