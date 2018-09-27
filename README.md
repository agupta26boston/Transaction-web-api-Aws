# csye6225-fall2018-repo-template
This the official private repository for the csye6225 network structures and cloud computing class. The repo contains the web application which will be deployed to a cloud service like AWS.

Team Members:
Ayush Gupta : gupta.ay@husky.neu.edu
Prasad Kanade : kanade.p@husky.neu.edu
Shivani Udupa : udupa.s@husky.neu.edu
Thushanth Bengre : bengre.t@husky.neu.edu


### Prerequisites

1. You will require git (/git GUI) installed in your local machine.
2. You will require java installed in your local machine. Either open JDK or the distribution from Oracle.
3. MySql server has to be installed in your machine. The workbench for mysql is optional.
4. An IDE such as Intellij
5. postgreSQL

### Installing

1. Install git.
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git
```
Run the command ```git --version``` after the installation to check whether the installation was successful. You will an output similar to the following:
```
git version 2.7.4
```

2. Install Java. The following are the commands to install open jdk, although you can install the Oracle distribution if you wish.
```
sudo apt-get install default jdk
```
To check whether the installation was successful, enter this command: ```java -version``` The following is a sample output displaying the version of OpenJDK Java that was installed:
```
openjdk version "1.8.0_151"
OpenJDK Runtime Environment (build 1.8.0_151-8u151-b12-0ubuntu0.16.04.2-b12)
OpenJDK 64-Bit Server VM (build 25.151-b12, mixed mode)
```
3. Install the MySQL server by using the Ubuntu package manager:
```
sudo apt-get update 
sudo apt-get install mysql-server
```
After the installation process is complete, run the following command to set up MySQL:
```
/usr/bin/mysql_secure_installation
```
The secure installer goes through the process of setting up MySQL including creating a root user password. It will prompt you for some security options, including removing remote access to the root user and setting the root password.

To check whether the installation was successful, enter this command: ```mysql --version``` The following is a sample output displaying the version of mysql that was installed:
```
mysql  Ver 14.14 Distrib 5.7.20, for Linux (x86_64) using  EditLine wrapper
```
4. Installing Intellij
Download the tar for intellij from https://www.jetbrains.com/idea/download/index.html#section=linux. After download the tar file execute the following commands
```
sudo tar -xvf <yourintellijtarfile.tar> -C /opt/
```
switch to the bin folder.
```
cd /opt/idea-IU-173.4301.25/bin
```
Run idea.sh from the bin subdirectory
```
sh ./idea.sh
```
If the installation was successful, idea intellij will start up.

5. postgreSQL.


## Running the tests

The unit tests can be found under the test package. The unit test were developed using Junit 4.

## Deployment

Has not been deployed as of now.

## Built With

* [Spring Boot](https://projects.spring.io/spring-boot) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management



