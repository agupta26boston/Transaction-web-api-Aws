#!/bin/bash
StackName=$1
stackstatus=""
createStackStatus=""
createFlag=true
DomainName=$2
AccessKeyId=$3
SecretAccessKey=$4
MySqlClientPass=$5


if [ -z "$StackName" ]; then
  echo "No stack name provided. Script exiting.."
  exit 1
fi
if [ -z "$DomainName" ]; then
  echo "No domain name provided. Script exiting.."
  exit 1
fi

Bucket=$DomainName.csye6225.com

echo "Starting $StackName network setup"

echo "Starting to create the stack......"

echo "$DomainName is my s3 bucket....."

createStackStatus=`aws cloudformation create-stack --stack-name $StackName \
	--template-body file://csye6225-cf-application.json \
	--parameters ParameterKey=EC2ImageId,ParameterValue=ami-9887c6e7 \
    ParameterKey=EC2InstanceType,ParameterValue=t2.micro \
    ParameterKey=EbsDeviceName,ParameterValue=/dev/sda1 \
    ParameterKey=EbsVolumeType,ParameterValue=gp2 \
    ParameterKey=EbsVolumeSize,ParameterValue=20\
    ParameterKey=DBName,ParameterValue=csye6225 \
    ParameterKey=DBUser,ParameterValue=csye6225master \
    ParameterKey=DBPassword,ParameterValue=csye6225password \
    ParameterKey=DBEngine,ParameterValue=MySQL \
    ParameterKey=DBAllocatedStorage,ParameterValue=100 \
    ParameterKey=DBEngineVersion,ParameterValue=5.6.37 \
    ParameterKey=DBInstanceClass,ParameterValue=db.t2.medium \
    ParameterKey=DBInstanceIdentifier,ParameterValue=csye6225-fall2018 \
    ParameterKey=KeyPairName,ParameterValue=csyekeypair \
    ParameterKey=bucketName,ParameterValue=$Bucket \
    ParameterKey=MySqlClientPass,ParameterValue=$MySqlClientPass`
  
   

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

myresources '`AWS::EC2::Instance`'
myresources '`AWS::DynamoDB::Table`'
myresources '`AWS::S3::Bucket`'
myresources '`AWS::RDS::DBInstance`'
myresources '`AWS::SNS::Topic`'
myresources '`AWS::Lambda::Permission`'

  stackstatus=`aws cloudformation describe-stacks --stack-name $StackName --query 'Stacks[*][StackStatus]' --output text`
  sleep 20
done

if [ "$createFlag" = true ]; then
  echo "Stack resources created successfully"
  aws cloudformation list-stack-resources --stack-name $StackName
fi
exit 0
