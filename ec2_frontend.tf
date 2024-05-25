resource "aws_instance" "frontend" {
  ami           = "ami-03aa885dc6576ab5f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.app_vpc.id
  security_groups = [aws_security_group.allow_tls.id]
  user_data = <<-EOF
                  #!/bin/bash
                  yum update -y
                  yum install -y nginx
                  echo 'Hello from New South Wales from Zorro' > /index.txt
                  systemctl start nginx
                  systemctl enable nginx
                  echo 'Hello from New South Wales from Zorro' > /usr/share/nginx/html/index.html 
                  EOF 
  tags = {
    Name = "tf-frontend"
  }
}