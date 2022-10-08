# launch template
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker ec2-user
# sudo usermod -a -G docker ec2-user


aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 877760304415.dkr.ecr.ap-south-1.amazonaws.com
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker ec2-user
docker pull 877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app:latest
docker run -p 8080:8080 --name employee-spring-docker-ec2-container 877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app:latest

# then go to browser paste public dns like this
# http://ec2-65-2-187-253.ap-south-1.compute.amazonaws.com:8080/
# http://ec2-65-2-187-253.ap-south-1.compute.amazonaws.com:8080/employees
docker stop employee-spring-docker-ec2-container && docker rm --force employee-spring-docker-ec2-container


# repeated command
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 877760304415.dkr.ecr.ap-south-1.amazonaws.com
sudo service docker start
docker pull 877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app:latest
docker run -p 8080:8080 --name employee-spring-docker-ec2-container 877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app:latest
docker stop employee-spring-docker-ec2-container && docker rm --force employee-spring-docker-ec2-container


#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker ec2-user
docker stop employee-spring-docker-ec2-container && docker rm --force employee-spring-docker-ec2-container
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 877760304415.dkr.ecr.ap-south-1.amazonaws.com
docker pull 877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app:latest
docker run -p 8080:8080 --name employee-spring-docker-ec2-container 877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app:latest


