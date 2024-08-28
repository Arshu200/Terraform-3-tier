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


# #!/bin/bash
#   # Update package list and install Apache, MySQL, and PHP
#   sudo apt-get update
#   sudo apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql

#   # Download and extract WordPress
#   sudo wget https://wordpress.org/latest.tar.gz
#   sudo tar -xzvf latest.tar.gz
#   sudo rsync -av wordpress/* /var/www/html/

#   # Set permissions for WordPress files
#   sudo chown -R www-data:www-data /var/www/html/
#   sudo chmod -R 755 /var/www/html/

#   # Move and configure wp-config.php
#   sudo mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

#   # Replace database connection settings in wp-config.php
#   sudo sed -i "s/database_name_here/${Wordpress}/" /var/www/html/wp-config.php
#   sudo sed -i "s/username_here/${admin}/" /var/www/html/wp-config.php
#   sudo sed -i "s/password_here/${mysql200}/" /var/www/html/wp-config.php
#   sudo sed -i "s/localhost/${demo.crw8c6mckgwz.us-east-1.rds.amazonaws.com}/" /var/www/html/wp-config.php

#   # Adjust Apache directory index order to prioritize index.php
#   sudo sed -i 's/DirectoryIndex.*$/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/' /etc/apache2/mods-enabled/dir.conf

#   # Restart Apache service
#   sudo systemctl restart apache2



#!/bin/bash
sudo apt update
sudo apt install -y apache2 mysql-client php php-mysql
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Configure WordPress
cat <<EOF > /var/www/html/wp-config.php
<?php
define( 'DB_NAME', '${db_name}' );
define( 'DB_USER', '${db_user}' );
define( 'DB_PASSWORD', '${db_password}' );
define( 'DB_HOST', '${db_endpoint}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( !defined('ABSPATH') )
define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
?>
EOF
