Terraform - Basic Commands
=========
Terraform templates used to create VPN (with public and private subnets), EKS, Managed Nodes, IAM and others.
### Miscelanea ###
  * Install → brew install terraform
  * terraform -help <command>

### Run ### 
  * terraform init → in the same directory you have the .tf file and then
  * terraform apply → it will create the AWS resource. The file terraform.tfstate will be created → the output shows the           execution plan in the same format as git diff command
    * This state file (terraform.tfstate) is extremely important; it keeps track of the IDs of created resources so that Terraform knows what it is managing. This file must be saved and distributed to anyone who might run Terraform.
You can manually change state through the command terraform state.
  * terraform show
  * terraform destroy → it will remove all resources created on AWS

