# <------------------Creating the launch configuration -------------------->
resource "aws_launch_configuration" "wordpress" {
  name_prefix   = "application-launch-configuration"
  image_id      = var.ami
  instance_type = var.type
  key_name      = "my-key-pair"
  # user_data     = file("demo.sh")
  user_data = base64encode(<<-EOF
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
      define( 'DB_NAME', '${var.db_name}' );
      define( 'DB_USER', '${var.db_user}' );
      define( 'DB_PASSWORD', '${var.db_pswd}' );
      define( 'DB_HOST', '${var.db_endpoint}' );
      define( 'DB_CHARSET', 'utf8' );
      define( 'DB_COLLATE', '' );
      $table_prefix = 'wp_';
      define( 'WP_DEBUG', false );
      if ( !defined('ABSPATH') )
      define('ABSPATH', dirname(__FILE__) . '/');
      require_once(ABSPATH . 'wp-settings.php');
      ?>
      EOF
  )
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = 10
    delete_on_termination = true
  }
  security_groups = [var.Application-SG]
  lifecycle {
    create_before_destroy = true
  }
}

# <-------------Creating the auto scaling group------------->
resource "aws_autoscaling_group" "app-asg" {
  launch_configuration      = aws_launch_configuration.wordpress.id
  name                      = "AutoScalingGroup"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = [var.privateSubnet1, var.privateSubnet2]
  target_group_arns         = [var.target_group_arn]
  tag {
    key                 = "Name"
    value               = "wordpress-asg"
    propagate_at_launch = true
  }
}




#<---------------------Launch template------------------------->


# resource "aws_launch_template" "wordpress" {
#   name_prefix   = "application-launch-template"
#   image_id      = var.ami
#   instance_type = var.type
#   key_name      = "my-key-pair"

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       delete_on_termination = true
#       volume_size           = 10
#     }
#   }

#   network_interfaces {
#     associate_public_ip_address = false
#     delete_on_termination       = true
#     security_groups             = [var.Application-SG]
#   }

#   tags = {
#     Name = "wordpress-template"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   user_data = base64encode(<<-EOF
#     #!/bin/bash
#     # Update package list and install Apache, MySQL, and PHP
#     apt-get update
#     apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql

#     # Download and extract WordPress
#     wget https://wordpress.org/latest.tar.gz
#     tar -xzvf latest.tar.gz
#     rsync -av wordpress/* /var/www/html/

#     # Set permissions for WordPress files
#     chown -R www-data:www-data /var/www/html/
#     chmod -R 755 /var/www/html/

#     # Move and configure wp-config.php
#     mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

#     # Replace database connection settings in wp-config.php
#     sed -i "s/database_name_here/${var.db_name}/" /var/www/html/wp-config.php
#     sed -i "s/username_here/${var.db_user}/" /var/www/html/wp-config.php
#     sed -i "s/password_here/${var.db_password}/" /var/www/html/wp-config.php
#     sed -i "s/localhost/${var.db_host}/" /var/www/html/wp-config.php

#     # Adjust Apache directory index order to prioritize index.php
#     sed -i 's/DirectoryIndex.*$/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/' /etc/apache2/mods-enabled/dir.conf

#     # Restart Apache service
#     systemctl restart apache2
#   EOF
#   )
# }
