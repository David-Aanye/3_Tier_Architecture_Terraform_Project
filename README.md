# 3-TIER APPLICATION ARCHITECTURE PROJECT USING TERRAFORM
...........................................................

3-tier application architecture comprising loosley coupled layers;
Presentation or Web-Tier (webtier)
Application-Tier (apptier)
Database-Tier (dbtier)
That achieves high scalability, availability, manageability and a secured architecture


STEPS
.................................................................
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
   
8. Database-Tier Setup
-Database subnet group and rds instance provisioned, configured and deployed to serve as the backend database
 
9. Setup App-Tier to Create AMI
Launch ec2-instance within an App-tier subnet with created IAM role attached
Connect to the ec2-instance through ssm agent  
Run the commands below to install MYSQL on App-tier instance

sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
sudo dnf install mysql-community-client -y

Use this command: mysql -h <RDS-Endpoint> -u <databse-username> -p <press enter>
and provide password to test connection between App-tier instance and and backend database

- Copy App-tier code from s3 bucket and assigned appropiate file permissions
sudo aws s3 cp s3://<MY-S3-BUCKET-NAME>/application-code/app-tier app-tier --recursive

cd app-tier
sudo chown -R ec2-user:ec2-user /home/ec2-user/app-tier
sudo chmod -R 755 /home/ec2-user/app-tier

-Installing and starting NODEJS

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

source ~/.bashrc

nvm install 16

nvm use 16

npm install -g pm2

npm install

npm audit fix

pm2 start index.js

pm2 startup 

sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.20.2/bin /home/ec2-user/.nvm/versions/node/v16.20.2/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp  

pm2 save

Create and save AMI(App-tier AMI) of App-tier instance(aws console) that has all the packages and app-tier applications installed.

5.  Setup Web-Tier to Create AIM
Launch ec2-instance within a Web-tier subnet with created IAM role attached

Connect to the ec2-instance through ssm agent  

Pull Web-tier code from s3 bucket and assign appropriate file permissions

sudo aws s3 cp s3://<MY-S3-BUCKET-NAME>/application-code/web-tier web-tier --recursive

sudo chown -R ec2-user:ec2-user /home/ec2-user

sudo chmod -R 755 /home/ec2-user

- Installing NODEJS(for using react application)
- 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

source ~/.bashrc

nvm install 16

nvm use 16

cd /home/ec2-user/web-tier

npm install

- Building the Nginx for production(installing Nginx)
  
sudo yum install nginx -y	
cd /etc/nginx
sudo mv nginx.conf nginx-backup.conf
add the Internal-Load-Balancer-DNS in the nginx.conf file & upload it to S3
sudo aws s3 cp s3://<MY-S3-BUCKET-NAME>/application-code/nginx.conf . 
sudo chmod -R 755 /home/ec2-user
sudo service nginx restart
sudo chkconfig nginx on

Create and save AMI named Web-tier AMI that has all the packages and Web-tier applications installed.

6. Provision, configure and deploy App-tier resources using terraform 
launch template using Web-tier AMI, internal load balancer, autoscaling group, sns topic and subscription

7. Provision, configure and deploy Web-tier resoruces using terraform
launch template using AMI created after the Web-tier setup, external load balancer, autoscaling group, sns topic and subscription

8. Configure S3 backend to store terraform state and state locking
9. Configured security groups (Database-Tier allows traffic only from a App-tier sg, App-Tier allows traffic only from internal load balancer(ILB) sg,
 ILB allows traffic only from Web-Tier Sg, Web-Tier allows traffic only from external LB)
)
10. Monitoring resources using terraform 
Vpc flow logs, external load balancer access and connection logs, 

Use the external load balancer dns name to test the architecture
Use sudo yum install stress -y and stress -c $(nproc) to test the autoscaling group after deployement

Terraform configuration involving all resources used in this project are contained
in .tf files 

