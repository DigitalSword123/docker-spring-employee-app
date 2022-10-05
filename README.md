# docker-spring-employee-app

ECR_REGISTRY
877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app

aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 877760304415.dkr.ecr.ap-south-1.amazonaws.com

docker build -t spring-boot-employee-app .

docker tag spring-boot-employee-app:latest 877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app:latest

docker push 877760304415.dkr.ecr.ap-south-1.amazonaws.com/spring-boot-employee-app:latest

https://cloudaffaire.com/how-to-create-ecs-task-definition-using-aws-cli/

sha256:34bbb63bbfbab61c0fd4367ca9d1f1403283d962d7ea87a1540f8e9e0e902f86

// https://github.com/awslabs/aws-cloudformation-templates/tree/master/aws/services/ECS
// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html