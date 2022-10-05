# docker-spring-employee-app

ECR_REGISTRY
877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app

aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 877760304415.dkr.ecr.ap-south-1.amazonaws.com

docker build -t spring-boot-employee-app .

docker tag spring-boot-employee-app:latest 877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app:latest

docker push 877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app:latest
