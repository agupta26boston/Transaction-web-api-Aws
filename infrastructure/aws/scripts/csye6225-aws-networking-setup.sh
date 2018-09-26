#!/bin/bash
#******************************************************************************
#    AWS VPC Creation Shell Script
#******************************************************************************
#
# SYNOPSIS
#    Automates the creation of a custom IPv4 VPC
#
# DESCRIPTION
#    This shell script leverages the AWS Command Line Interface (AWS CLI) to
#    automatically create a custom VPC. 
#
#=============================================================================
STACKNAME=$1
VPC_NAME="$STACKNAME-aws-vpc"
GATEWAY_NAME="$STACKNAME-aws-gateway"
RT_NAME="$STACKNAME-aws-routeTable"
VPC_CIDR="10.0.0.0/16"
SUBNET_ONE_PUB_CIDR="10.0.1.0/24"
SUBNET_ONE_PUB_AZ="us-east-1a"
SUBNET_ONE_PUB_NAME="$STACKNAME-PUBLIC -SN - us-east-1a"
SUBNET_ONE_PRI_CIDR="10.0.4.0/24"
SUBNET_ONE_PRI_AZ="us-east-1a"
SUBNET_ONE_PRI_NAME="$STACKNAME-PRIVATE -SN - us-east-1a"
SUBNET_TWO_PUB_CIDR="10.0.2.0/24"
SUBNET_TWO_PUB_AZ="us-east-1b"
SUBNET_TWO_PUB_NAME="$STACKNAME-PUBLIC -SN - us-east-1b"
SUBNET_TWO_PRI_CIDR="10.0.5.0/24"
SUBNET_TWO_PRI_AZ="us-east-1b"
SUBNET_TWO_PRI_NAME="$STACKNAME-PRIVATE -SN - us-east-1b"
SUBNET_THREE_PUB_CIDR="10.0.3.0/24"
SUBNET_THREE_PUB_AZ="us-east-1c"
SUBNET_THREE_PUB_NAME="$STACKNAME-PUBLIC -SN - us-east-1c"
SUBNET_THREE_PRI_CIDR="10.0.6.0/24"
SUBNET_THREE_PRI_AZ="us-east-1c"
SUBNET_THREE_PRI_NAME="$STACKNAME-PRIVATE -SN - us-east-1c"


if [ -z "$STACKNAME" ]; then
  echo "No stack name provided. Script exiting.."
  exit 1
fi

# Create VPC
echo "Creating VPC ON Stack '$STACKNAME'"
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $VPC_CIDR \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text)
if [ $? -ne "0" ]
    then
        echo "VPC creation failed"
        exit 1
    else
        echo "  VPC ID '$VPC_ID' CREATED"
fi


# Add Name tag to VPC
aws ec2 create-tags \
  --resources $VPC_ID \
  --tags "Key=Name,Value=$VPC_NAME" 
echo "  VPC ID '$VPC_ID' NAMED as '$VPC_NAME'."

# Create Public SubnetOne
echo "Creating Public SubnetOne..."
SUBNET_ONE_PUBLIC_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_ONE_PUB_CIDR \
  --availability-zone $SUBNET_ONE_PUB_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text)
if [ $? -ne "0" ]
    then
        echo "SubnetOne creation failed"
        exit 1
    else
echo "  Subnet One ID '$SUBNET_ONE_PUBLIC_ID' CREATED in '$SUBNET_ONE_PUB_AZ'" \
  "Availability Zone."
fi

# Add Name tag to Public Subnet
aws ec2 create-tags \
  --resources $SUBNET_ONE_PUBLIC_ID \
  --tags "Key=Name,Value=$SUBNET_ONE_PUB_NAME" 
echo "  Subnet One ID '$SUBNET_ONE_PUBLIC_ID' NAMED as" \
  "'$SUBNET_ONE_PUB_NAME'."

# Create Private SubnetOne
echo "Creating Public SubnetOne..."
SUBNET_ONE_PRIVATE_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_ONE_PRI_CIDR \
  --availability-zone $SUBNET_ONE_PRI_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text)
if [ $? -ne "0" ]
    then
        echo "SubnetOne creation failed"
        exit 1
    else
echo "  Subnet One ID '$SUBNET_ONE_PRIVATE_ID' CREATED in '$SUBNET_ONE_PRI_AZ'" \
  "Availability Zone."
fi

# Add Name tag to Public Subnet
aws ec2 create-tags \
  --resources $SUBNET_ONE_PRIVATE_ID \
  --tags "Key=Name,Value=$SUBNET_ONE_PRI_NAME" 
echo "  Subnet One ID '$SUBNET_ONE_PRIVATE_ID' NAMED as" \
  "'$SUBNET_ONE_PRI_NAME'."

# Create Public SubnetTwo
echo "Creating Public SubnetTwo..."
SUBNET_TWO_PUBLIC_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_TWO_PUB_CIDR \
  --availability-zone $SUBNET_TWO_PUB_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text)
if [ $? -ne "0" ]
    then
        echo "SubnetTwo creation failed"
        exit 1
    else
echo "  Subnet Two ID '$SUBNET_TWO_PUBLIC_ID' CREATED in '$SUBNET_TWO_PUB_AZ'" \
  "Availability Zone."
fi

# Add Name tag to Public Subnet
aws ec2 create-tags \
  --resources $SUBNET_TWO_PUBLIC_ID \
  --tags "Key=Name,Value=$SUBNET_TWO_PUB_NAME" 
echo "  Subnet Two ID '$SUBNET_TWO_PUBLIC_ID' NAMED as" \
  "'$SUBNET_TWO_PUB_NAME'."

# Create Private SubnetTwo
echo "Creating Private SubnetTwo..."
SUBNET_TWO_PRIVATE_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_TWO_PRI_CIDR \
  --availability-zone $SUBNET_TWO_PRI_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text)
if [ $? -ne "0" ]
    then
        echo "SubnetTwo creation failed"
        exit 1
    else
echo "  Subnet Two ID '$SUBNET_TWO_PRIVATE_ID' CREATED in '$SUBNET_TWO_PRI_AZ'" \
  "Availability Zone."
fi

# Add Name tag to Public Subnet
aws ec2 create-tags \
  --resources $SUBNET_TWO_PRIVATE_ID \
  --tags "Key=Name,Value=$SUBNET_TWO_PRI_NAME" 
echo "  Subnet Two ID '$SUBNET_TWO_PRIVATE_ID' NAMED as" \
  "'$SUBNET_TWO_PRI_NAME'."

# Create Public SubnetThree
echo "Creating Public SubnetThree..."
SUBNET_THREE_PUBLIC_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_THREE_PUB_CIDR \
  --availability-zone $SUBNET_THREE_PUB_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text)
if [ $? -ne "0" ]
    then
        echo "SubnetThree creation failed"
        exit 1
    else
echo "  Subnet Three ID '$SUBNET_THREE_PUBLIC_ID' CREATED in '$SUBNET_THREE_PUB_AZ'" \
  "Availability Zone."
fi

# Add Name tag to Public Subnet
aws ec2 create-tags \
  --resources $SUBNET_THREE_PUBLIC_ID \
  --tags "Key=Name,Value=$SUBNET_THREE_PUB_NAME" 
echo "  Subnet Three ID '$SUBNET_THREE_PUBLIC_ID' NAMED as" \
  "'$SUBNET_THREE_PUB_NAME'."

# Create Private SubnetThree
echo "Creating Private SubnetThree..."
SUBNET_THREE_PRIVATE_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_THREE_PRI_CIDR \
  --availability-zone $SUBNET_THREE_PRI_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text)
if [ $? -ne "0" ]
    then
        echo "SubnetThree creation failed"
        exit 1
    else
echo "  Subnet Three ID '$SUBNET_THREE_PRIVATE_ID' CREATED in '$SUBNET_THREE_PRI_AZ'" \
  "Availability Zone."
fi

# Add Name tag to Public Subnet
aws ec2 create-tags \
  --resources $SUBNET_THREE_PRIVATE_ID \
  --tags "Key=Name,Value=$SUBNET_THREE_PRI_NAME" 
echo "  Subnet Three ID '$SUBNET_THREE_PRIVATE_ID' NAMED as" \
  "'$SUBNET_THREE_PRI_NAME'."

# Create Internet gateway
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
  --output text)
if [ $? -ne "0" ]
    then
        echo "IG creation failed"
        exit 1
    else
echo "  Internet Gateway ID '$IGW_ID' CREATED."
fi

# Add Name tag to IG
aws ec2 create-tags \
  --resources $IGW_ID \
  --tags "Key=Name,Value=$GATEWAY_NAME" 
echo "  GATEWAY ID '$IGW_ID' NAMED as '$GATEWAY_NAME'."

# Attach Internet gateway to your VPC
echo "Attaching Internet Gateway..."
aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID \
  --internet-gateway-id $IGW_ID
echo "  Internet Gateway ID '$IGW_ID' ATTACHED to VPC ID '$VPC_ID'."

# Create Route Table
echo "Creating Route Table..."
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text)
if [ $? -ne "0" ]
    then
        echo "Route Table creation failed"
        exit 1
    else
echo "  Route Table ID '$ROUTE_TABLE_ID' CREATED."
fi

# Add Name tag to RT
aws ec2 create-tags \
  --resources $ROUTE_TABLE_ID \
  --tags "Key=Name,Value=$RT_NAME" 
echo "  ROUTE TABLE ID '$ROUTE_TABLE_ID' NAMED as '$RT_NAME'."

# Create route to Internet Gateway
echo "Creating route to Internet Gateway..."
RESULT=$(aws ec2 create-route \
  --route-table-id $ROUTE_TABLE_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID)
if [ $? -ne "0" ]
    then
        echo "Route creation failed"
        exit 1
    else
echo "  Route to '0.0.0.0/0' via Internet Gateway ID '$IGW_ID' ADDED to" \
  "Route Table ID '$ROUTE_TABLE_ID'."
fi

# Associate SubnetOne with Route Table
echo "Associating SubnetOne with Route Table ..."
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_ONE_PUBLIC_ID \
  --route-table-id $ROUTE_TABLE_ID)
if [ $? -ne "0" ]
    then
        echo "SubnetOne Linking failed"
        exit 1
    else
echo "  Subnet Two ID '$SUBNET_ONE_PUBLIC_ID' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_ID'." 
fi


# Associate SubnetTwo with Route Table
echo "Associating SubnetTwo with Route Table ..."
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_TWO_PUBLIC_ID \
  --route-table-id $ROUTE_TABLE_ID)
if [ $? -ne "0" ]
    then
        echo "SubnetTwo Linking failed"
        exit 1
    else
echo "  Subnet Two ID '$SUBNET_TWO_PUBLIC_ID' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_ID'."
fi

# Associate SubnetThree with Route Table
echo "Associating SubnetThree with Route Table ..."
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_THREE_PUBLIC_ID \
  --route-table-id $ROUTE_TABLE_ID)
if [ $? -ne "0" ]
    then
        echo "SubnetThree Linking failed"
        exit 1
    else
echo "  Subnet Three ID '$SUBNET_THREE_PUBLIC_ID' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_ID'."
fi


# Enable Auto-assign Public IP on Public Subnet
echo "Enabling Auto Assign on Public Subnet One..."
aws ec2 modify-subnet-attribute \
  --subnet-id $SUBNET_ONE_PUBLIC_ID \
  --map-public-ip-on-launch
if [ $? -ne "0" ]
    then
        echo "Enabling auto assign on subnet one failed"
        exit 1
    else
echo "  'Auto-assign Public IP' ENABLED on Public Subnet ID" \
  "'$SUBNET_ONE_PUBLIC_ID'."
fi

echo "Enabling Auto Assign on Public Subnet Two..."
aws ec2 modify-subnet-attribute \
  --subnet-id $SUBNET_TWO_PUBLIC_ID \
  --map-public-ip-on-launch
if [ $? -ne "0" ]
    then
        echo "Enabling auto assign on subnet two failed"
        exit 1
    else
echo "  'Auto-assign Public IP' ENABLED on Public Subnet ID" \
  "'$SUBNET_TWO_PUBLIC_ID'."
fi

echo "Enabling Auto Assign on Public Subnet Three..."
aws ec2 modify-subnet-attribute \
  --subnet-id $SUBNET_THREE_PUBLIC_ID \
  --map-public-ip-on-launch
if [ $? -ne "0" ]
    then
        echo "Enabling auto assign on subnet three failed"
        exit 1
    else
echo "  'Auto-assign Public IP' ENABLED on Public Subnet ID" \
  "'$SUBNET_THREE_PUBLIC_ID'."
fi


echo "COMPLETED"
