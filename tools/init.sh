#!/bin/bash

if [[ ! -z "$GIT_NAME" ]]
then
    git config --global user.name "$GIT_NAME"
    echo "Git config: $GIT_NAME"
fi

mkdir -p /root/.ssh

if [[ ! -z "$GIT_EMAIL" ]]
then
    git config --global user.email "$GIT_EMAIL"
    echo "Git config: $GIT_EMAIL"
    if [[ ! -f /root/.ssh/id_rsa ]]
    then
        ssh-keygen -t rsa -b 4096 -C "${GIT_MAIL}" -N "" -f /root/.ssh/id_rsa
        cat /root/.ssh/id_rsa.pub
    fi
fi

if [[ ! -z "$GIT_HOST" ]] || [[ ! -z "$GIT_IP" ]]
then
    ssh-keyscan -p7999 -H ${GIT_HOST} >> /root/.ssh/known_hosts
    ssh-keyscan -p7999 -H ${GIT_IP} >> /root/.ssh/known_hosts
fi

/usr/sbin/sshd -D