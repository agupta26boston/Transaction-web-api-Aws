#!/bin/bash
#******************************************************************************
#    AWS VPC Teardown Shell Script
#******************************************************************************
#
# SYNOPSIS
#    Automates the teardown of a network
#
# DESCRIPTION
#    This shell script tearsdown a network levaraging the tools available on awsCLI
#
#=============================================================================
STACKNAME=$1

if [ -z "$STACKNAME" ]; then
  echo "No stack name provided. Script exiting.."
  exit 1
fi



vpcid=`aws ec2 describe-vpcs --filters "Name=tag:Name,Values='$STACKNAME-aws-vpc'" --query Vpcs[*].VpcId --output text`
    echo "# deleting vpc (${vpcid}) ..."



#while [ $a -lt 100 ]
#do
subnetIDList=`aws ec2 describe-subnets --filters "Name=vpc-id,Values='${vpcid}'" --query Subnets[].SubnetId --output text`
OIFS="$IFS"
IFS=$'\t'
read -a subnetArray <<< "${subnetIDList}"
IFS="$OIFS"

for i in "${subnetArray[@]}"
do
	echo "# deleting Subnet {$i}... "
  aws ec2 delete-subnet --subnet-id ${i}
done
  
  
  
  
    igwID=`aws ec2 describe-internet-gateways --filter "Name=attachment.vpc-id,Values='${vpcid}'" --query InternetGateways[].InternetGatewayId --output text`
       echo "#   deleting internet gateway (${igwID}) ..."

         aws ec2 detach-internet-gateway --internet-gateway-id=${igwID} --vpc-id=${vpcid}
         aws ec2 delete-internet-gateway --internet-gateway-id=${igwID}
    

    routeID=`aws ec2 describe-route-tables --filter "Name=vpc-id,Values='${vpcid}'"  --query RouteTables[].RouteTableId --output text` 
        echo "#   deleting route table (${routeID}) ..."

        aws ec2 delete-route-table --route-table-id ${routeID}
OIFS="$IFS"
IFS=$'\t'
read -a routearray <<< "${routeID}"
IFS="$OIFS"

for j in "${routearray[@]}"
do
	echo "# deleting RouteTable {$j}... "
   aws ec2 delete-route-table --route-table-id ${j}
done

   aws ec2 delete-vpc --vpc-id ${vpcid}
  

echo "Completed"