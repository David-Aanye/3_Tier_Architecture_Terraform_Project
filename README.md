# 3-TIER APPLICATION ARCHITECTURE PROJECT USING TERRAFORM
...........................................................

3-tier application architecture comprising loosley coupled layers;
Presentation or Web-Tier (webtier)
Application-Tier (apptier)
Database-Tier (dbtier)
That achieves high scalability, availability, manageability and a secured architecture

..........................................................................................................................
STEPS
...........................................................................................................................

A. VPC and networking

1. Provison VPC
2. two public subnets across 2 AZs for Web-Tier(achieves high availability)
3. two private subnets across 2 AZs for App-Tier (achieves high availability)
4. two private subnets across 2 AZs for Database-Tier (achieves high availability)
5. two internet gateway, route table and associations for the public subnets(Web-Tier)
6. two elastic ips and nat gateway for each AZ with route tables and associations(App-Tier)

B. S3 Bucket and IAM Role Setup using terraform
1. Provision S3 bucket and upload application code
2. Create IAM role with SSMManagedInstance and AmazonS3ReadOnlyAccess to access the Applicaction ccode in s3 bucket
   
C. Database-Tier Setup
1. Database subnet group and rds instance provisioned, configured and deployed to serve as the backend database
 
D. Setup App-Tier to Create AMI
1. Launch ec2-instance within an App-tier subnet with created IAM role attached
2. Connect to the ec2-instance through ssm agent
3. Run the commands below to install MYSQL on App-tier instance
4. sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
5. sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
6. sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
7. sudo dnf install mysql-community-client -y
  
9. Use this command: mysql -h <RDS-Endpoint> -u <databse-username> -p <press enter>
and provide password to test connection between App-tier instance and and backend database


E. Copy App-tier code from s3 bucket and assigned appropiate file permissions
1. sudo aws s3 cp s3://<MY-S3-BUCKET-NAME>/application-code/app-tier app-tier --recursive
2. sudo chown -R ec2-user:ec2-user /home/ec2-user/app-tier
3. sudo chmod -R 755 /home/ec2-user/app-tier

F. Installing and starting NODEJS
1. curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
2. source ~/.bashrc
3. nvm install 16
4. nvm use 16
5. npm install -g pm2
6. npm install
7. npm audit fix
8. pm2 start index.js
9. pm2 startup
10. sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.20.2/bin /home/ec2-user/.nvm/versions/node/v16.20.2/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp
11. pm2 save
12. Create and save AMI(App-tier AMI) of App-tier instance(aws console) that has all the packages and app-tier applications installed.

G. Setup Web-Tier to Create AIM
1. Launch ec2-instance within a Web-tier subnet with created IAM role attached
2. Connect to the ec2-instance through ssm agent
3. Pull Web-tier code from s3 bucket and assign appropriate file permissions
4. sudo aws s3 cp s3://<MY-S3-BUCKET-NAME>/application-code/web-tier web-tier --recursive
5. sudo chown -R ec2-user:ec2-user /home/ec2-user
6. sudo chmod -R 755 /home/ec2-user
7. Installing NODEJS(for using react application)
8. curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
9. source ~/.bashrc
10. nvm install 16
11. nvm use 16
12. npm install
13. Building the Nginx for production(installing Nginx)
14. sudo yum install nginx -y
15. sudo mv nginx.conf nginx-backup.conf
16. add the Internal-Load-Balancer-DNS in the nginx.conf file & upload it to S3
17. sudo aws s3 cp s3://<MY-S3-BUCKET-NAME>/application-code/nginx.conf .
18. sudo chmod -R 755 /home/ec2-user
19. sudo service nginx restart
20. sudo chkconfig nginx on
21. Create and save AMI named Web-tier AMI that has all the packages and Web-tier applications installed.

H. Provision, configure and deploy App-tier resources using terraform 
1. launch template using Web-tier AMI, internal load balancer, autoscaling group, sns topic and subscription

I. Provision, configure and deploy Web-tier resoruces using terraform
1. launch template using AMI created after the Web-tier setup, external load balancer, autoscaling group, sns topic and subscription

J. Configure S3 backend to store terraform state and state locking

K. Configured security groups (Database-Tier allows traffic only from a App-tier sg, App-Tier allows traffic only from internal load balancer(ILB) sg,
 ILB allows traffic only from Web-Tier Sg, Web-Tier allows traffic only from external LB)
 
L. Monitoring resources using terraform 
1. Vpc flow logs, external load balancer access and connection logs, 

Use the external load balancer dns name to test the architecture
Use sudo yum install stress -y and stress -c $(nproc) to test the autoscaling group after deployement

Terraform configuration involving all resources used in this project are contained
in .tf files 

