# ubuntu-ansible
In this project, by using Docker, [Ansible](https://github.com/ansible/ansible) and [ansible_spec](https://github.com/volanja/ansible_spec) runtime environment is created on Ubuntu.

If further interest arises, try adding more target hosts, changing the playbook, or adding test code.

> [!NOTE]
> Zennにも記事を投稿しているので、詳しく知りたい方はそちらもご参照ください。
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

## Run Ansible playbook and run tests with ansible_spec
```
root@ubuntu-c:/etc/ansible/# ansible-playbook site.yml
root@ubuntu-c:/etc/ansible/# rake all
```

## Make sure Apache is running in your browser
Enter <http://localhost:8080/> in your browser

If the `Apache2 Default Page`is displayed, it means that the ansible execution and the test with ansible_spec were successful.