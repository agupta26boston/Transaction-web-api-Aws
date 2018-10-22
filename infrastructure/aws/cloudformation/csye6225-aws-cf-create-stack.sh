#!/bin/bash
StackName=$1
stackstatus=""
createStackStatus=""
createFlag=true

if [ -z "$StackName" ]; then
  echo "No stack name provided. Script exiting.."
  exit 1
fi
echo "Starting $StackName network setup"

echo "Starting to create the stack......"

createStackStatus=`aws cloudformation create-stack --stack-name $StackName --template-body file://csye6225-cf-networking.json`

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
      bash ./csye6225-aws-cf-terminate-stack.sh $StackName
      break
    fi
  }

myresources '`AWS::EC2::VPC`'
myresources '`AWS::EC2::RouteTable`'
myresources '`AWS::EC2::Route`'
myresources '`AWS::EC2::InternetGateway`'
myresources '`AWS::EC2::VPCGatewayAttachment`'
myresources '`AWS::EC2::Subnet`'
myresources '`AWS::EC2::SubnetRouteTableAssociation`'
myresources '`AWS::RDS::DBSubnetGroup`'
myresources '`AWS::EC2::SecurityGroup`'

  stackstatus=`aws cloudformation describe-stacks --stack-name $StackName --query 'Stacks[*][StackStatus]' --output text`
  sleep 20
done

if [ "$createFlag" = true ]; then
  echo "Stack resources created successfully"
  aws cloudformation list-stack-resources --stack-name $StackName
fi
exit 0
