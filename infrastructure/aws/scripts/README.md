# Script
Amazon Web Services CloudFormationis a free service that provides Amazon Web Service (AWS) customers with the tools they 
need to create and manage the infrastructure a particular software application requires to run on Amazon Web Services.

CloudFormation has two parts: templates and stacks. A template is a JavaScript Object Notation (JSON) text file. The file, 
which is declarative and not scripted, defines what AWS resources or non-AWS resources are required to run the application. 
For example, the template may declare that the application requires an Amazon Elastic Compute Cloud (EC2) instance and an 
Identity and Access Management (IAM) policy.

# csye6225-aws-networking-setup.sh
This script takes a string name which it uses as alias for the stack name it creates. The script will create a VPC, Routetable, Route and an Internet gateway 
which it will attach to the VPC.

To run this:
```
./csye6225-aws-networking-setup.sh <stackname>
```

# csye6225-aws-networking-teardown.sh

This script takes a string which is the name of the alias you want to delete. The script tears down all the resources which is 
was created with the alias provided. The script will tear down the VPC, Routetable, Route and an Internet gateway which is 
attached to the VPC.

To run this:
```
./csye6225-aws-networking-teardown.sh <stackname>
```
