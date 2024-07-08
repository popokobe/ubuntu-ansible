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
root@ubuntu-c:/# ansible -m ping ubuntu-t1
```