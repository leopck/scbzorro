resource "aws_instance" "backend" {
  ami           = "ami-03aa885dc6576ab5f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.app_vpc.id

  security_groups = [aws_security_group.allow_tls.id]
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y git
              curl -sL https://rpm.nodesource.com/setup_14.x | bash -
              yum install -y nodejs
              
              git clone https://github.com/bezkoder/nodejs-express-mysql.git /home/ec2-user/nodejs-express-mysql
              cd /home/ec2-user/nodejs-express-mysql

              sed -i 's/localhost/${aws_db_instance.example.address}/g' app/config/db.config.js
              sed -i 's/root/${var.dbusername}/g' app/config/db.config.js
              sed -i 's/123456/${var.dbpassword}/g' app/config/db.config.js
              sed -i 's/testdb/${aws_db_instance.example.db_name}/g' app/config/db.config.js
              
              npm install
              node server.js &
              EOF

  tags = {
    Name = "tf-backend"
  }
}
