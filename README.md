# arma-automation

![arma-automation-logo](https://user-images.githubusercontent.com/56150254/70861144-22e51400-1f7e-11ea-84cf-6767f836db27.png)

Ansible Template and Roles for automating the setup of an ARMA 3 Server
Note: Supports Ubuntu 18.04 only

Still very much a work in progress.

Run with: ansible-playbook -i hosts --ask-pass armaplaybook.yml

If you want to run entirely by command line without editing the defaults or hosts files you can do this:
run with: ansible-playbook -i hosts --user yoursudoer --ask-pass --become --ask-become-pass armaplaybook.yml -e "steam_username=username steam_password=password"
