## コンテナ立ち上げ
```
docker compose up -d
```

## Ansibleコントロールノードへ接続
```
docker exec -it ubuntu-c /bin/bash
```

## Ansible, ansible_spec実行
```
root@ubuntu-c:/# rake all
root@ubuntu-c:/# ansible-playbook site.yaml
root@ubuntu-c:/# rake all
```

## ブラウザでApache起動確認
ブラウザに <http://localhost:8080/> を入力

Apache2 Default Pageが表示されればOK