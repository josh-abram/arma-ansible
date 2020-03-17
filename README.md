# arma-automation

![arma-automation-logo](https://user-images.githubusercontent.com/56150254/70861144-22e51400-1f7e-11ea-84cf-6767f836db27.png)

Ansible Template and Roles for automating the setup of an ARMA 3 Server
Note: Only tested on Ubuntu 18.04, in theory should work on any distro with aptitude.

Still very much a work in progress. You can join the discord here for support: https://discord.gg/wN4xNZp

Run with: ansible-playbook -i hosts --ask-pass armaplaybook.yml

If you want to run entirely by command line without editing the defaults or hosts files you can do this:

ansible-playbook -i hosts --user yoursudoer --ask-pass --become --ask-become-pass armaplaybook.yml -e "steam_username=username steam_password=password"
