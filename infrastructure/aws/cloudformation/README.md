# CloudFormation
Amazon Web Services CloudFormation is a free service that provides Amazon Web Service (AWS) customers with the tools they 
need to create and manage the infrastructure a particular software application requires to run on Amazon Web Services.

CloudFormation has two parts: templates and stacks. A template is a JavaScript Object Notation (JSON) text file. The file, 
which is declarative and not scripted, defines what AWS resources or non-AWS resources are required to run the application. 
For example, the template may declare that the application requires an Amazon Elastic Compute Cloud (EC2) instance and an 
Identity and Access Management (IAM) policy.

# csye6225-aws-cf-create-stack.sh
This script takes a string name which it uses for the stack name it creates. The script uses a json file, known as a cloud
formation template, to create the resources it needs. The script will create a VPC, Routetable, Route and an Internet gateway 
which it will attach to the VPC.

To run this:
```
./csye6225-aws-cf-create-stack.sh <stackname>
```

# csye6225-aws-cf-terminate-stack.sh

This script takes a string which is the name of the stack you want to delete. The script tears down all the resources which is 
attached to the stack with the stack name provided. The script will tear down the VPC, Routetable, Route and an Internet gateway 
which is attached to the VPC.

To run this:
```
./csye6225-aws-cf-terminate-stack.sh <stackname>
```
