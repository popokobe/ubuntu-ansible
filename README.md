## コンテナ立ち上げ
```
docker compose up -d
```

## Ansibleコントロールノードへ接続
```
docker exec -it ubuntu-c /bin/bash
```

## Ansible実行
```
root@ubuntu-c:/# ansible-playbook -i hosts playbook.yaml
```

## Apache起動確認
ブラウザに <http://localhost:8080/> を入力
Apache2 Default Pageが表示されればOK