#!/bin/bash
StackName=$1
stackstatus=""
createStackStatus=""
createFlag=true
DomainName=$2
AppBucket=""

if [ -z "$StackName" ]; then
  echo "No stack name provided. Script exiting.."
  exit 1
fi
if [ -z "$DomainName" ]; then
  echo "No domain name provided. Script exiting.."
  exit 1
fi
Bucket=code-deploy.$DomainName
AppBucket =$DomainName.csye6225.com

echo "Starting $StackName network setup"

echo "Starting to create the stack......"

echo "$Bucket is my code-deploy s3 bucket....."

createStackStatus=`aws cloudformation create-stack --stack-name $StackName \
  --template-body file://csye6225-cf-cicd.json \
  --parameters ParameterKey=BucketName,ParameterValue=$Bucket \
    ParameterKey=AppBucket,ParameterValue=$AppBucket \
  --capabilities CAPABILITY_NAMED_IAM`

if [ -z "$createStackStatus" ]; then
  echo "Failed to create stack"
  exit 1
fi

until [ "$stackstatus" = "CREATE_COMPLETE" ]; do
  echo "Adding resources to the stack......"

  #ADD function to check resources
  myresources(){
    resourceStatus=`aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType=='$@' && ResourceStatus==\`CREATE_FAILED\`)][ResourceStatus]' --output text`
    if [ "$resourceStatus" = "CREATE_FAILED" ]; then
      createFlag=false
      echo "$@ creation failed! "
      aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType=='$@' && ResourceStatus==`CREATE_FAILED`)]'
      echo "deleting stack..... "
      bash ./csye6225-aws-cf-terminate-application-stack.sh $StackName $DomainName
      break
    fi
  }

  myresources '`AWS::S3::Bucket`'
  myresources '`AWS::IAM::Policy`'
  myresources '`AWS::IAM::ManagedPolicy`'
  myresources '`AWS::IAM::InstanceProfile`'
  myresources '`AWS::IAM::Role`'
  myresources '`AWS::CodeDeploy::Application`'
  myresources '`AWS::CodeDeploy::DeploymentConfig`'
  myresources '`AWS::CodeDeploy::DeploymentGroup`'

  stackstatus=`aws cloudformation describe-stacks --stack-name $StackName --query 'Stacks[*][StackStatus]' --output text`
  sleep 20
done

if [ "$createFlag" = true ]; then
  echo "Stack resources created successfully"
  aws cloudformation list-stack-resources --stack-name $StackName
fi
exit 0
