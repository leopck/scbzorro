resource "aws_instance" "frontend" {
  ami           = "ami-03aa885dc6576ab5f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.app_vpc.id
  security_groups = [aws_security_group.allow_tls.id]
  user_data = <<-EOF
                  #!/bin/bash
                  yum update -y
                  yum install -y nginx git
                  systemctl start nginx
                  systemctl enable nginx
                  #git clone https://github.com/zhemein/nodejs-express-mysql 
                  git clone https://github.com/leopck/nodejs-express-mysql 
                  cp nodejs-express-mysql/frontend/* /usr/share/nginx/html/
                  source /etc/environment
                  sed -i "s|%%API_URL%%|$BACKEND_URL|g" /usr/share/nginx/html/index.html
                  systemctl restart nginx
                  #echo 'Hello from New South Wales from Zorro' > /usr/share/nginx/html/index.html 
                  EOF 
  tags = {
    Name = "tf-frontend"
  }
}
