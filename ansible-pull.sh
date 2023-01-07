
#!/bin/bash
touch /opt/user-data.log
id >>/opt/user-data.log
labauto ansible
ansible-pull -i localhost, -U https://github.com/d-devop/roboshop-ansible roboshop.yml -e ROLE_NAME=${component} -e ENV=${env} | tee -a /opt/user-data.log
