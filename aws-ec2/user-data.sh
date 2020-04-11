#!/bin/sh
set -x -e
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo tee /var/www/html/index.html > /dev/null <<EOT
<html>
<body>
<h1>Hello World</h1>
</body>
</html>
EOT
