#!/bin/bash
StackName=$1
DomainName=$2

if [ -z "$StackName" ]; then
  echo "No stack name provided. Script exiting.."
  exit 1
fi
if [ -z "$DomainName" ]; then
  echo "No domain name provided. Script exiting.."
  exit 1
fi
DomainName=$DomainName.csye6225.com

if [ -z "$StackName" ]; then
  echo "No stack name provided. Script exiting.."
  exit 1
fi
echo "Starting $StackName network setup"

echo "Starting to create the stack......"


createStackStatus=`aws cloudformation create-stack --stack-name $StackName  --template-body file://ci-cd.json --capabilities CAPABILITY_IAM --capabilities CAPABILITY_NAMED_IAM --parameters ParameterKey=bucketName,ParameterValue=$DomainName` 
   resourceStatus=`aws cloudformation describe-stack-events --stack-name $StackName --output text`
   echo $resourceStatus
  #ADD function to check resources
  myresources(){
    echo "check"
    resourceStatus=`aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType=='$@' && ResourceStatus==\`CREATE_FAILED\`)][ResourceStatus]' --output text`
    if [ "$resourceStatus" = "CREATE_FAILED" ]; then
      createFlag=false
      echo "$@ creation failed! "
      aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType=='$@' && ResourceStatus==`CREATE_FAILED`)]'
      echo "deleting stack..... "
      bash ./csye6225-aws-cf-terminate-application-stack.sh $StackName
      break
    fi
  }
myresources '`AWS::IAM::Role`'
myresources '`AWS::IAM::Role`'
myresources '`AWS::IAM::ManagedPolicy`'
myresources '`AWS::IAM::ManagedPolicy`'
myresources '`AWS::S3::Bucket`'
myresources '`AWS::CodeDeploy::Application`'
myresources '`AWS::CodeDeploy::DeploymentGroup`'


if [ -z "$createStackStatus" ]; then
  echo "Failed to create stack"
  exit 1
fi

exit 0

