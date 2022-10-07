echo "------------------printing all files in target directory end --------------------------"
echo "STATE_BUCKET" $STATE_BUCKET
echo "AWSENV" $AWSENV
echo "AWS_REGION" $AWS_REGION
echo "AWS_ACCOUNT_NUMBER" $AWS_ACCOUNT_NUMBER
echo "DYNDB_TBL" $DYNDB_TBL
echo "IAM_ROLE" $IAM_ROLE

echo "**********************************************************"
pwd

export VAR_FILE=vars/$DEPLOY_ENVIRONMENT-ap-south-1.tfvars

cat ${VAR_FILE}

echo "DEPLOY_ENVIRONMENT : " $DEPLOY_ENVIRONMENT

echo "app version : " ${APP_VERSION}
export TF_VAR_version=${APP_VERSION}
echo "TF_VAR_version : " ${TF_VAR_version}

terraform init \
 -backend-config="bucket=node-terraform-state-bucket" \
 -backend-config="key=employee-spring-jdbc-docker/$DEPLOY_ENVIRONMENT/terraform.tfstate" \
 -backend-config="access_key=${AWS_ACCESS_KEY}" \
 -backend-config="secret_key=${AWS_SECRET_KEY}"

terraform plan -var-file="${VAR_FILE}" -out=plan.tfplan

terraform apply "plan.tfplan"