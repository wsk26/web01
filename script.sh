#!/bin/bash
set -e

HOST="web01"
IP_ADDR="10.1.20.31"
IP6_ADDR="2001:db8:1001:20::31"

echo "==> Настройка $HOST..."
hostnamectl set-hostname $HOST.dmz.ws.kz
timedatectl set-timezone Asia/Almaty
apt-get update -y
export DEBIAN_FRONTEND=noninteractive
apt-get install -y locales nginx

sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
update-locale LANG=en_US.UTF-8

echo "==> Настройка сети..."
cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address $IP_ADDR/24
    gateway 10.1.20.1
iface eth0 inet6 static
    address $IP6_ADDR/64
    gateway 2001:db8:1001:20::1
EOF
systemctl restart networking || true

echo "==> Настройка Nginx и контента..."
mkdir -p /opt/wwwroot
echo "<h1>Welcome to WS Almaty 2026 ($HOST)</h1>" > /opt/wwwroot/index.html
echo "$HOST" > /opt/wwwroot/whoami
echo "<h1>404 - Запрашиваемая страница не найдена</h1>" > /opt/wwwroot/404.html

cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /opt/wwwroot;
    index index.html;

    error_page 404 /404.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /whoami {
        default_type text/plain;
        alias /opt/wwwroot/whoami;
    }
}
#!/bin/bash
set -e

HOST="web01"
IP_ADDR="10.1.20.31"
IP6_ADDR="2001:db8:1001:20::31"

echo "==> Настройка $HOST..."
hostnamectl set-hostname $HOST.dmz.ws.kz
timedatectl set-timezone Asia/Almaty
apt-get update -y
export DEBIAN_FRONTEND=noninteractive
apt-get install -y locales nginx

sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
update-locale LANG=en_US.UTF-8

echo "==> Настройка сети..."
cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address $IP_ADDR/24
    gateway 10.1.20.1
iface eth0 inet6 static
    address $IP6_ADDR/64
    gateway 2001:db8:1001:20::1
EOF
systemctl restart networking || true

echo "==> Настройка Nginx и контента..."
mkdir -p /opt/wwwroot
echo "<h1>Welcome to WS Almaty 2026 ($HOST)</h1>" > /opt/wwwroot/index.html
echo "$HOST" > /opt/wwwroot/whoami
echo "<h1>404 - Запрашиваемая страница не найдена</h1>" > /opt/wwwroot/404.html

cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /opt/wwwroot;
    index index.html;

    error_page 404 /404.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /whoami {
        default_type text/plain;
        alias /opt/wwwroot/whoami;
    }
}
EOF
systemctl restart nginx

echo "==> Готово! $HOST настроен."
