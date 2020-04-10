#!/bin/sh
sudo yum update -y
echo yes | sudo mdadm \
  --create \
  --verbose \
  /dev/md0 \
  --level=0 \
  --name=html \
  --raid-devices=2 \
  /dev/sdf \
  /dev/sdg
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm.conf
sudo mkfs -t xfs -L html /dev/md0
sudo mkdir -p /var/www/html
echo "LABEL=html /var/www/html xfs defaults,nofail 0 2" | sudo tee -a /etc/fstab
sudo mount -a
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo tee /var/www/html/index.html > /dev/null <<EOT
<html>
<body>
<h1>Hello World</h1>
</body>
</html>
