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

  vpcStatus=`aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType==\`AWS::EC2::VPC\` && ResourceStatus==\`CREATE_FAILED\`)][ResourceStatus]' --output text`
  routeTableStatus=`aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType==\`AWS::EC2::RouteTable\` && ResourceStatus==\`CREATE_FAILED\`)][ResourceStatus]' --output text`
  routeStatus=`aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType==\`AWS::EC2::Route\` && ResourceStatus==\`CREATE_FAILED\`)][ResourceStatus]' --output text`
  internetGatewayStatus=`aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType==\`AWS::EC2::InternetGateway\` && ResourceStatus==\`CREATE_FAILED\`)][ResourceStatus]' --output text`
  vpcGatewayAttachmentStatus=`aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType==\`AWS::EC2::VPCGatewayAttachment\` && ResourceStatus==\`CREATE_FAILED\`)][ResourceStatus]' --output text`

  if [ "$vpcStatus" = "CREATE_FAILED" ]; then
    createFlag=false
    echo "vpc creation failed! "
    aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType==`AWS::EC2::VPC` && ResourceStatus==`CREATE_FAILED`)]'
    echo "deleting stack..... "
    bash ./csye6225-aws-networking-teardown.sh $StackName
    break
  fi

  if [ "$routeTableStatus" = "CREATE_FAILED" ]; then
    createFlag=false
    echo "RouteTable creation failed! "
    aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType==`AWS::EC2::VPC` && ResourceStatus==`CREATE_FAILED`)]'
    echo "deleting stack..... "
    bash ./csye6225-aws-networking-teardown.sh $StackName
    break
  fi

  if [ "$routeStatus" = "CREATE_FAILED" ]; then
    createFlag=false
    echo "Route creation failed! "
    aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType==`AWS::EC2::VPC` && ResourceStatus==`CREATE_FAILED`)]'
    echo "deleting stack..... "
    bash ./csye6225-aws-networking-teardown.sh $StackName
    break
  fi

  if [ "$vpcGatewayAttachmentStatus" = "CREATE_FAILED" ]; then
    createFlag=false
    echo "VPCGatewayAttachment creation failed! "
    aws cloudformation describe-stack-events --stack-name $StackName --query 'StackEvents[?(ResourceType==`AWS::EC2::VPC` && ResourceStatus==`CREATE_FAILED`)]'
    echo "deleting stack..... "
    bash ./csye6225-aws-networking-teardown.sh $StackName
    break
  fi

  stackstatus=`aws cloudformation describe-stacks --stack-name $StackName --query 'Stacks[*][StackStatus]' --output text`
  sleep 20
done

if [ "$createFlag" = true ]; then
  echo "Stack resources created successfully"
  aws cloudformation list-stack-resources --stack-name $StackName
fi
exit 0
