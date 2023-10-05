provider "aws" {
  region = "us-east-1"
}

# Definición de una instancia EC2
resource "aws_instance" "MiAppPython" {
  ami             = "ami-09cf206358add540b"
  instance_type   = "c5a.xlarge"
  key_name        = "credibanco"
  security_groups = ["grup-security-credibanco"]
  
  tags = {
    Name = "MiAppPython2023"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y && \
              sudo apt-get -y install apt-transport-https \
              ca-certificates \
              curl \
              gnupg2 \
              software-properties-common && \
              curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
              sudo add-apt-repository \
              "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
              $(lsb_release -cs) \
              stable" && \
              sudo apt-get update && \
              sudo apt-get -y install docker-ce

              sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

              sudo echo "dckr_pat_Zkro9Z4Yjy7PDv4U3P1_EmqLeDU" | docker login --username alvaro2042 --password-stdin

              docker pull alvaro2042/jenkins
	      docker pull alvaro2042/app_credi-banco

	      cd /home/ubuntu/jenkins

	      chmod -R jenkins_home
 
	      docker run -d --user root --name jenkins -p 8080:8080 -p 50000:50000 -v $PWD/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -e LANG=es_ES.UTF-8 jenkins/credibanco
	      docker run -d --name app-credibanco -p 5000:5000 alvaro2042/app_credi-banco

              EOF
}

resource "aws_eip" "MiAppPythonEIP" {
  instance = aws_instance.MiAppPython.id
}

