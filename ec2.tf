# Create EC2 instance
resource "aws_instance" "terraform_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnet.default.id
  # User data script to install and start Apache
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "<h1>Hello from Terraform Lab!</h1>" > /var/www/html/index.html
              echo "<p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>" >> /var/www/html/index.html
              echo "<p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>" >> /var/www/html/index.html
              EOF

  tags = {
    Name        = "terraform-instance"
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}
