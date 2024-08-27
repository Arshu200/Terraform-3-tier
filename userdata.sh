 user_data = base64encode(<<-EOF
  #!/bin/bash
  # Update package list and install Apache, MySQL, and PHP
  apt-get update
  apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql

  # Download and extract WordPress
  wget https://wordpress.org/latest.tar.gz
  tar -xzvf latest.tar.gz
  rsync -av wordpress/* /var/www/html/

  # Set permissions for WordPress files
  chown -R www-data:www-data /var/www/html/
  chmod -R 755 /var/www/html/

  # Move and configure wp-config.php
  mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

  # Replace database connection settings in wp-config.php
  sed -i "s/database_name_here/${var.db_name}/" /var/www/html/wp-config.php
  sed -i "s/username_here/${var.db_user}/" /var/www/html/wp-config.php
  sed -i "s/password_here/${var.db_password}/" /var/www/html/wp-config.php
  sed -i "s/localhost/${var.db_host}/" /var/www/html/wp-config.php

  # Adjust Apache directory index order to prioritize index.php
  sed -i 's/DirectoryIndex.*$/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/' /etc/apache2/mods-enabled/dir.conf

  # Restart Apache service
  systemctl restart apache2
EOF
)

# sudo nano /etc/apache2/mods-enabled/dir.conf