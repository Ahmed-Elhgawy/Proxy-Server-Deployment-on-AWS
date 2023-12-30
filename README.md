# Proxy Server Deployment on AWS

Using terraform <img src="img/Terraform.png" width="30" height="30" align="center"/> as Intrastracture as a code (IaC) tool to deploy infrastracture on Amazon Web Server (AWS) cloud provider <img src="img/aws.png" width="40" height="40" align="center"/>.

### Infrastracture
<img src="img/infra.png" alt="infra"/>

And Then using Ansible <img src="img/Ansible.png" width="30" height="30" align="center"/> to manage the instances through bastion host to connect to servers and to install apache2 on backend servers and nginx <img src="img/Nginx.png" width="30" height="30" align="center"/> on frontend server

And using Jenkins <img src="img/Jenkins.png" width="40" height="40" align="center"/> we can deploy the infrastracture through CI/CD Pipeline.

### Path Flow
<img src="img/flow.png" alt="flow"/>

## Prerequests in server which will run the code:

1- Terraform CLI

2- Python3

3- Ansible

## Run Without Jenkins:

You will need to insure your AWS configration and authentication on you AWS email, And then enter varaibles you need in terraform code in **terraform/terraform.tfvars** file, the varaibles you need to enter is:

1- region (Optional)        --> The Region where the terraform code will be performed

2- cidr (Optional)          --> IP range which will be used in virtual private network

3- azs (Optional)           --> Avaliability zones the number of instance will change depends on the number of azs

4- instance-ami (Optional)  --> The OS that will be used in instance

5- instance-type (Optional) --> The resources that will be used in instance

6- key-pair(Required)       --> The priavte key that will be used to connect to instance

And if your public key isn't in **~/.ssh/** directory you need to change its path to **~/.ssh/privateKeyName.pem** or change the path in **template/ssh_config** file to **~/path/to/your/private/key/private_key.pem**

And after finish you can run the code by moving to terraform directory `cd terraform/` and run the command `terraform apply -auto-approve`

## RUN With Jenjins:

You need to install the following plugin:

1- Pipeline: AWS Steps (Required)
 
2- Slack Notification (Optional) --> if installed you need to edit Jenkinsfile 

And then you need to add credential for aws and with **ID: terraform**, and edit the key-name in Jenkins file with available key-name