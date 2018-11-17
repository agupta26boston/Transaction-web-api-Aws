#!/bin/bash
StackName=$1
stackstatus=""
createStackStatus=""
createFlag=true
DomainName=$2

if [ -z "$StackName" ]; then
  echo "No stack name provided. Script exiting.."
  exit 1
fi
if [ -z "$DomainName" ]; then
  echo "No domain name provided. Script exiting.."
  exit 1
fi
Bucket=serverless.$DomainName
AppBucket=$DomainName.csye6225.com

echo "Starting $StackName network setup"

echo "Starting to create the stack......"

echo "$Bucket is my code-deploy s3 bucket....."

createStackStatus=`aws cloudformation create-stack --stack-name $StackName \
  --template-body file://csye6225-cf-serverless.json \
  --parameters ParameterKey=bucketName,ParameterValue=$Bucket \
    ParameterKey=domainName,ParameterValue=$DomainName \
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
      bash ./csye6225-aws-cf-terminate-serverless-stack.sh $StackName
      break
    fi
  }

  myresources '`AWS::IAM::Role`'
  myresources '`AWS::SNS::Topic`'
  myresources '`AWS::Lambda::Function`'
  myresources '`AWS::Lambda::Permission`'

  stackstatus=`aws cloudformation describe-stacks --stack-name $StackName --query 'Stacks[*][StackStatus]' --output text`
  sleep 20
done

if [ "$createFlag" = true ]; then
  echo "Stack resources created successfully"
  aws cloudformation list-stack-resources --stack-name $StackName
fi
exit 0