# ubuntu-ansible
Through a simple hands-on session, get to run [Ansible](https://github.com/ansible/ansible) and [ansible_spec](https://github.com/volanja/ansible_spec) on Ubuntu.
In this hands-on, use Ansible to install apache2 and start the web server, and check if apache2 is installed with ansible_spec.

If further interest arises, try adding more target hosts, changing the playbook, or adding test code.

> [!NOTE]
> Zennにも記事を投稿しているので、詳しく知りたい方はそちらもご参照ください。
>
> [Dockerで鍵認証によるAnsibleとansible_specの実行環境を構築](https://zenn.dev/popokobe/articles/ubuntu-ansible)

## Build images and start containers
Image builds take a certain amount of time. Just be patient and wait it out.
```
docker compose up -d --build
```

## Connect to Ansible control node
```
docker compose exec ubuntu-c bash
```

## Hands on
### SSH key-based authentication
```
root@ubuntu-c:/etc/ansible# ssh root@ubuntu-t1 -o PreferredAuthentications=password
root@ubuntu-t1: Permission denied (publickey).

root@ubuntu-c:/etc/ansible# ssh root@ubuntu-t1
Welcome to Ubuntu 24.04 LTS (GNU/Linux 6.6.31-linuxkit aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.
Last login: Sat Aug 10 14:41:38 2024 from 172.18.0.3
root@ubuntu-t1:~#
```

### Ansible setup
```
root@ubuntu-c:/etc/ansible# vim hosts
root@ubuntu-c:/etc/ansible# cat hosts
[webservers]
ubuntu-t1 ansible_ssh_private_key_file=/root/.ssh/id_ed25519
root@ubuntu-c:/etc/ansible# ansible -m ping webservers
ubuntu-t1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
root@ubuntu-c:/etc/ansible# cd roles
root@ubuntu-c:/etc/ansible/roles# mkdir -p apache2/tasks   
root@ubuntu-c:/etc/ansible/roles# cd apache2/tasks
root@ubuntu-c:/etc/ansible/roles/apache2/tasks# vim main.yml
root@ubuntu-c:/etc/ansible/roles/apache2/tasks# cat main.yml
- name: Install apache package
  apt:
    name: apache2
    state: present

- name: Start apeche2 server
  service:
    name: apache2
    state: started
root@ubuntu-c:/etc/ansible# cd /etc/ansible
root@ubuntu-c:/etc/ansible# vim site.yml
root@ubuntu-c:/etc/ansible# cat site.yml 
- name: Deploy apache server
  gather_facts: no
  hosts: webservers
  roles:
  - apache2

root@ubuntu-c:/etc/ansible# ssh ubuntu-t1
Welcome to Ubuntu 24.04 LTS (GNU/Linux 6.6.31-linuxkit aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.
Last login: Sat Aug 10 14:57:28 2024 from 172.18.0.3
root@ubuntu-t1:~# apt list --installed | grep apache2
root@ubuntu-t1:~# exit
logout
Connection to ubuntu-t1 closed.
root@ubuntu-c:/etc/ansible# ansible-playbook site.yml

PLAY [Deploy apache server] **********************************************************************************************************************

TASK [apache2 : Install apache package] **********************************************************************************************************
changed: [ubuntu-t1]

TASK [apache2 : Start apeche2 server] ************************************************************************************************************
changed: [ubuntu-t1]

PLAY RECAP ***************************************************************************************************************************************
ubuntu-t1                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

root@ubuntu-c:/etc/ansible# ssh ubuntu-t1
Welcome to Ubuntu 24.04 LTS (GNU/Linux 6.6.31-linuxkit aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.
Last login: Sat Aug 10 14:57:28 2024 from 172.18.0.3
root@ubuntu-t1:~# apt list --installed | grep apache2

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

apache2-bin/noble-updates,noble-security,now 2.4.58-1ubuntu8.4 arm64 [installed,automatic]
apache2-data/noble-updates,noble-security,now 2.4.58-1ubuntu8.4 all [installed,automatic]
apache2-utils/noble-updates,noble-security,now 2.4.58-1ubuntu8.4 arm64 [installed,automatic]
apache2/noble-updates,noble-security,now 2.4.58-1ubuntu8.4 arm64 [installed]
root@ubuntu-t1:~# exit
logout
Connection to ubuntu-t1 closed.
root@ubuntu-c:/etc/ansible#
```

Open [http://localhost:8080/](http://localhost:8080/) in a browser and check that the Apache2 Default Page is displayed

### ansible_spec setup
```
root@ubuntu-c:/etc/ansible# ruby --version
ruby 3.1.6p260 (2024-05-29 revision a777087be6) [aarch64-linux]
root@ubuntu-c:/etc/ansible# vim Gemfile
root@ubuntu-c:/etc/ansible# cat Gemfile 
source 'https://rubygems.org'

gem 'ansible_spec', '0.3.2'

# === Gem for public key authentication with ansible_spec ===
gem 'ed25519', '1.3.0'
gem 'bcrypt_pbkdf', '1.1.1'
# ===========================================================
root@ubuntu-c:/etc/ansible# bundle install
Don't run Bundler as root. Bundler can ask for sudo if it is needed, and installing your bundle as root will break this application for all
non-root users on this machine.
Fetching gem metadata from https://rubygems.org/.............
Resolving dependencies...
Fetching multi_json 1.15.0
.
.
.
Fetching ansible_spec 0.3.2
Installing ansible_spec 0.3.2
Bundle complete! 3 Gemfile dependencies, 39 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
root@ubuntu-c:/etc/ansible# ls
Gemfile  Gemfile.lock  ansible.cfg  hosts  roles  site.yml
root@ubuntu-c:/etc/ansible# ansiblespec-init
                create  spec
                create  spec/spec_helper.rb
                create  Rakefile
                create  .ansiblespec
                create  .rspec
root@ubuntu-c:/etc/ansible# ls
Gemfile  Gemfile.lock  Rakefile  ansible.cfg  hosts  roles  site.yml  spec
root@ubuntu-c:/etc/ansible# mkdir -p roles/apache2/spec
root@ubuntu-c:/etc/ansible# cd roles/apache2/spec
root@ubuntu-c:/etc/ansible/roles/apache2/spec# vim apache2_spec.rb
root@ubuntu-c:/etc/ansible/roles/apache2/spec# cat apache2_spec.rb 
require 'spec_helper'

describe package('apache2') do
  it { should be_installed }
end
root@ubuntu-c:/etc/ansible/roles/apache2/spec# cd /etc/ansible
root@ubuntu-c:/etc/ansible# rake -T
rake all                              # Run serverspec to all test
rake serverspec:Deploy apache server  # Run serverspec for Deploy apache server
root@ubuntu-c:/etc/ansible# rake all
Run serverspec for Deploy apache server to {"name"=>"ubuntu-t1 ansible_ssh_private_key_file=/root/.ssh/id_ed25519", "port"=>22, "connection"=>"ssh", "uri"=>"ubuntu-t1", "private_key"=>"/root/.ssh/id_ed25519"}
/opt/rbenv/versions/3.1.6/bin/ruby -I/opt/rbenv/versions/3.1.6/lib/ruby/gems/3.1.0/gems/rspec-support-3.13.1/lib:/opt/rbenv/versions/3.1.6/lib/ruby/gems/3.1.0/gems/rspec-core-3.13.0/lib /opt/rbenv/versions/3.1.6/lib/ruby/gems/3.1.0/gems/rspec-core-3.13.0/exe/rspec --pattern \{roles\}/\{apache2\}/spec/\*_spec.rb

Package "apache2"
/opt/rbenv/versions/3.1.6/lib/ruby/gems/3.1.0/gems/specinfra-2.90.1/lib/specinfra/backend/ssh.rb:82:in `create_ssh': Passing nil, or [nil] to Net::SSH.start is deprecated for keys: user
  is expected to be installed

Finished in 0.40293 seconds (files took 0.27431 seconds to load)
1 example, 0 failures
```