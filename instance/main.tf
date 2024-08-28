# <------------------Creating the Key-pair ------------------------->
resource "aws_key_pair" "Key-pair" {
  key_name   = "my-key-pair"
  public_key = file("C:/Users/hp/Desktop/CloudifyOPS/TerraformDemo/my-key-pair.pub")
}

# <-----------------Creating the bastion host -1 instance----------->

resource "aws_instance" "Bastion-Host1" {
  ami             = var.ami
  instance_type   = var.type
  key_name        = "my-key-pair"
  security_groups = [var.Bastion-SG]
  subnet_id       = var.PublicSubnet1

  provisioner "file" {
    source      = "C:/Users/hp/Desktop/CloudifyOPS/TerraformDemo/my-key-pair"
    destination = "/home/ubuntu/my-key-pair"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:/Users/hp/Desktop/CloudifyOPS/TerraformDemo/my-key-pair")
      host        = self.public_ip
    }

  }
  tags = {
    Name = "BastionHost1"
  }
}


# <-----------------Creating the bastion host -2 instance----------->

resource "aws_instance" "Bastion-Host2" {
  ami             = var.ami
  instance_type   = var.type
  key_name        = "my-key-pair"
  security_groups = [var.Bastion-SG]
  subnet_id       = var.PublicSubnet2

  provisioner "file" {
    source      = "C:/Users/hp/Desktop/CloudifyOPS/TerraformDemo/my-key-pair"
    destination = "/home/ubuntu/my-key-pair"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("C:/Users/hp/Desktop/CloudifyOPS/TerraformDemo/my-key-pair")
      host        = self.public_ip
    }

  }
  tags = {
    Name = "BastionHost2"
  }
}



# <---------------------Creating the Application server-1 -------------------->

resource "aws_instance" "app-server-1" {
  ami             = var.ami
  instance_type   = var.type
  security_groups = [var.Application-SG]
  key_name        = "my-key-pair"
  subnet_id       = var.privateSubnet1
  user_data       = file("demo.sh")
  tags = {
    Name = "Application-Web1"
  }
}

# <---------------------Creating the Application server-2 -------------------->

resource "aws_instance" "app-server-2" {
  ami             = var.ami
  instance_type   = var.type
  security_groups = [var.Application-SG]
  key_name        = "my-key-pair"
  subnet_id       = var.privateSubnet2
  user_data       = file("demo.sh")
  tags = {
    Name = "Application-Web2"
  }

}



























# <----------------Creating the provisioner--------------------->
# provisioner "remote-exec" {

#   connection {
#     type                = "ssh"
#     user                = "ubuntu"
#     private_key         = file("C:/Users/hp/Desktop/CloudifyOPS/TerraformDemo/my-key-pair")
#     host                = self.private_ip                  # Use private IP for private instances
#     bastion_host        = aws_instance.Bastion-Host1.public_ip # Assuming you have a bastion host defined
#     bastion_user        = "ubuntu"                         # User for bastion host
#     bastion_private_key = file("C:/Users/hp/Desktop/CloudifyOPS/TerraformDemo/my-key-pair")
#   }

#   inline = [
#     "sudo apt-get update -y",
#     "sudo apt-get install -y apache2",
#     "sudo systemctl start apache2",
#     "sudo systemctl enable apache2",
#     # Create a simple HTML website
#     "echo '<!DOCTYPE html>' | sudo tee /var/www/html/index.html",
#     "echo '<html>' | sudo tee -a /var/www/html/index.html",
#     "echo '<head>' | sudo tee -a /var/www/html/index.html",
#     "echo '<title>Welcome to My Website</title>' | sudo tee -a /var/www/html/index.html",
#     "echo '<style>' | sudo tee -a /var/www/html/index.html",
#     "echo 'body { font-family: Arial, sans-serif; background-color: #f4f4f4; text-align: center; padding: 50px; }' | sudo tee -a /var/www/html/index.html",
#     "echo 'h1 { color: #333; }' | sudo tee -a /var/www/html/index.html",
#     "echo 'p { color: #666; }' | sudo tee -a /var/www/html/index.html",
#     "echo '.container { max-width: 600px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }' | sudo tee -a /var/www/html/index.html",
#     "echo '</style>' | sudo tee -a /var/www/html/index.html",
#     "echo '</head>' | sudo tee -a /var/www/html/index.html",
#     "echo '<body>' | sudo tee -a /var/www/html/index.html",
#     "echo '<div class=\"container\">' | sudo tee -a /var/www/html/index.html",
#     "echo '<h1>Welcome to My Website!</h1>' | sudo tee -a /var/www/html/index.html",
#     "echo '<p>This is a simple web page deployed using Terraform.</p>' | sudo tee -a /var/www/html/index.html",
#     "echo '<p>Your instance private IP is: ${aws_instance.app-server-2.private_ip}</p>' | sudo tee -a /var/www/html/index.html",
#     "echo '</div>' | sudo tee -a /var/www/html/index.html",
#     "echo '</body>' | sudo tee -a /var/www/html/index.html",
#     "echo '</html>' | sudo tee -a /var/www/html/index.html",
#     "echo 'chmod +x /tmp/script.sh'"
#   ]
# }



# <------------------------Providing the user data ----------------------->
# user_data = base64encode(<<-EOF
#   #!/bin/bash
#   # Update package list and install Apache, MySQL, and PHP
#   apt-get update
#   apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql

#   # Download and extract WordPress
#   wget https://wordpress.org/latest.tar.gz
#   tar -xzvf latest.tar.gz
#   rsync -av wordpress/* /var/www/html/

#   # Set permissions for WordPress files
#   chown -R www-data:www-data /var/www/html/
#   chmod -R 755 /var/www/html/

#   # Move and configure wp-config.php
#   mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

#   # Replace database connection settings in wp-config.php
#   sed -i "s/database_name_here/${var.db_name}/" /var/www/html/wp-config.php
#   sed -i "s/username_here/${var.db_user}/" /var/www/html/wp-config.php
#   sed -i "s/password_here/${var.db_password}/" /var/www/html/wp-config.php
#   sed -i "s/localhost/${var.db_host}/" /var/www/html/wp-config.php

#   # Adjust Apache directory index order to prioritize index.php
#   sed -i 's/DirectoryIndex.*$/DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm/' /etc/apache2/mods-enabled/dir.conf

#   # Restart Apache service
#   systemctl restart apache2
# EOF
# )
