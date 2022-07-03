#!/bin/bash
apt install apache2 -y
systemctl enable apache2
systemctl start apache2
echo "<h1>Hello from $HOSTNAME </h1>" > /var/www/html/index.html
