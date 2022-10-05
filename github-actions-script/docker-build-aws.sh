aws ecr create-repository \
    --repository-name employee_spring_boot \
    --region ap-south-1

ecrDockerImageTag="$AWS_ACCOUNT.dkr.ecr.ap-south-1.amazonaws.com/$ECR_NS:$imageTag"
echo $ecrDockerImageTag
docker build --network=host --tag $ecrDockerImageTag .
echo "docker push started"
docker push $ecrDockerImageTag
echo "docker push completed"
docker image rm $ecrDockerImageTag


# deploy script
echo $(pwd)
imageTag=$version
echo $imageTag
instanceList=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $AWS_ASG_GROUP_NAME --profile $profile)
echo $instanceList
instanceIds=($($(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $AWS_ASG_GROUP_NAME --profile $profile | jq '.AutoScalingGroups[0].Instances' | jq -c '.[]' | grep Healthy | jq '.InstanceId' | sed -e 's/"//g'))
echo "${instanceIds[0]} and ${instanceIds[1]}"
ecrDockerImageTag="$AWS_ACCOUNT.dkr.ecr.ap-south-1.amazonaws.com/$ECR_NS:$imageTag"

# pull docker
pullCmd="docker pull ${ecrDockerImageTag}"
echo "pull command started"
commands="{\"commands\":[\"#!/bin/bash\",\"eval $(aws ecr get-login --profile "$profile" --region "ap-south-1" --no-include-email)\",\"${pullCmd}\"]}"
echo $commands

env='dev'
echo "deploying to ENV:$env"

date