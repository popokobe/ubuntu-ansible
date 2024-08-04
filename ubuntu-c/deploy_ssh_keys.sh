#!/bin/bash

# SSHキーの生成
ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -q -C "" -N ""

# SSHキーのコピー
sshpass -p "password" ssh-copy-id -i /root/.ssh/id_ed25519.pub -o StrictHostKeyChecking=no root@ubuntu-t1

# パスワード認証を無効にするためのコマンドをターゲットノードに送信し、sshdを再起動
# service restart sshするとコンテナが落ちるので、kill -HUPしている
ssh root@ubuntu-t1 -p 22  << 'EOF'
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
kill -HUP $(pgrep -x sshd)
EOF

# コンテナが終了しないように無限ループ
tail -f /dev/null
