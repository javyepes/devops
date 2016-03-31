---
# This a playbook that can be ran adhoc or bootstrapped for your build server scripts.  The playbook creates the rundeck user,rd group(or whatevery admin group you want to create), gives sudo access to the group, copies the ssh public key, creates the temp folder, and simulate the 1st ssh session
- name: Create Rundeck User
  hosts: # enter you host group
  user: # enter your user
  become: yes
  vars:
    rd_pp: # enter password hash
    rd_user: # enter the rundeck user
    rd_group: # enter the rundeck group
    rd_tmpdir: # enter the location of the tmp dir
  tasks:
    - name: create group
      group: name={{ rd_group }} state=present
      tags: group

    - name: give the group sudo access without passwd prompts
      lineinfile: "dest=/etc/sudoers state=present regexp="^%{{ rd_group }}" line="%{{ rd_group }} ALL=(ALL) NOPASSWD: ALL'"
      tags: group

    - name: create new user
      user: name={{ rd_user }} password={{rd_pp}} state=present group={{ rd_group }} home=/var/lib/rundeck shell=/bin/bash generate_ssh_key=yes ssh_key_bits=2048 ssh_key_file=.ssh/id_rsa
      register: create_users
      tags: user

    - name: copy public key
      authorized_key: user=rundeck key={{ lookup('file', './templates/rundeck-public-key') }} # in this playbook I am using a public template
      tags: sshkey

    - name: create tmp folder
      file: path=/var/lib/rundeck/{{ rd_tmpdir }} state=directory owner={{ rd_user }} group={{ rd_group }}
      tags: tmpdir

    - name: simulate 1st login
      locate_action: ssh -t -o StrictHostKeychecking=no {{ ansible_hosts }} "date" creates=~/1st-login-marker
      tags: rundeck
