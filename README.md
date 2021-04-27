# README #

This README would normally document whatever steps are necessary to get your application up and running.

# Installing Terraform #

Navigate to https://www.terraform.io/ and install the client. Extract the executable into a folder called ‘Terraform’ on your drive.
Next, add Terraform to your path (Windows). This can be found by opening up settings, and typing Environment, then selecting “edit the system environment variables”. Next, click on Environment Variables, and edit the one called ‘Path’, adding the path to your Terraform folder. Select ‘ok’. To test that Terraform is successfully installed, run 
‘Terraform version’ in Powershell.
Next, we need to download the Azure CLI. For windows, you can find it here: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli 
Once this is complete, run ‘az login’ in powershell, and login to your account.
If you’re using VSCode, you may have to open up Bash in Cloud Shell in order to run resources.

# Installing Commands #

Terraform apply 
This command will read your *.tf files and apply the terraform code to the cloud provider you have specified
Terraform plan
If you only want to run a plan to see what changes terraform will do
Terraform init
Every time you add a new module, a provider, or the first time you want to use terraform within a project directory
Terraform destroy
When you want to clean up all the resources you have created within a demo
Terraform help
To get a full list of commands

SSH into resource
Once a VM has been created, you can ssh through terraform. First, create your Keys with the command ‘ssh-keygen -f mykey’. To confirm the key has been created, run 
‘ls mykey*’
Once you have run ‘terraform apply’ in order to deploy the resource and it has been created, you can ssh into the public ip of the machine. First, find the public ip on Azure Portal. Then, run ‘ssh your.ip.here -i mykey -l yourAdminUsername’. To logout, simply type ‘logout’.



Importing resources from Azure into Terraform
Example: Resource group
	‘terraform import <Terraform Resource Name>.<Resource Label> <Azure Resource ID>’
Visit https://registry.terraform.io/ for proper documentation



#Overview of Starter Files for Terraform#


1. Main.tf is the file that allocates the resource group and provider. The first thing you should do is run terraform init to initialize the backend for the provider. If you want to change provider (ex. AWS), you must rerun the command terraform init. 
2. Vars.tf defines the main variables used throughout the other files, most notably the location variable and the global prefix used for naming.
3. Instance.tf is the file where we allocate specific information regarding the VM, Network Interface, and Public IP. Note that there are comments placed that show you where to make changes regarding OS image and SSH Keys.
4. Network.tf defines the Virtual Network, Subnet, and Network Security Group. Note that you can modify the security rules for Inbound/Outbound ports.
5. Terraform.tfstate is used to store information about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures. For all practical purposes, this file should not be modified.


Deploying Terraform Infrastructure

There are 3 resource group options we can deploy:


MoodleDev resource group
NMap Scanning Lab resource group
Packet Analysis resource group

Each of these are included in the scripts listed here. https://bitbucket.org/ProfessionalSquid/terraform-scripts/src/master/

Note: Please make sure you have installed the prerequisites listed in “Installing Terraform”
In order to deploy these resources to your subscription, follow these steps:

Open VSCode (or a similar environment)
Navigate your way to the correct folder that holds the Terraform scripts, and change directory into the appropriate resource group you wish to deploy
Run terraform init
If you wish to change credentials for your machine, navigate to the ‘instance.tf’ file, and alter the variables ‘admin_username’ and/or ‘admin_password’. 
Note: If you change the username parameter, be sure to include this change in the ‘path’ variable located within the ‘ssh_keys’ block. 
Run terraform plan. Ensure that the files can compile without error.
Run terraform apply. Double check that no errors appear. 
Note: Upon creating a Kali Linux instance, an error may appear saying that the Custom image requires Plan information in the request. If this appears, navigate to this thread for help: https://discuss.hashicorp.com/t/issue-creating-linux-vm-using-kali-linux-custom-image/19344 
To remove these resources, run terraform destroy. 



Creating SSH Keys

If you wish to access your machines without the use of password authentication, then SSH is the most secure option available. If you are using MacOS or Linux, a simple ssh-keygen will suffice (see SSH into resource). However, if you are using Windows, this is the guide for you!

First, download PuTTY: https://www.putty.org/ 
Next, download PuTTYgen: https://www.puttygen.com/
Within PuTTYgen, generate a Public/Private key pair. 
Save the public key as “mykey.pub” in the folder containing the terraform scripts.
Save the private key as “mykey” in the same folder. This can optionally be password protected, and will automatically be saved as a .ppk file.
Click Conversions, then Export OpenSSH Key. This is actually the key we use in MacOS and Linux. Save this as “mykey.pem”.
Within PuTTY:
Follow the path Connection->SSH->Auth, click Browse, and select “mykey” private key. 
Once loaded, you can return to the Session tab, and type in the username followed by ‘@’ followed by the IP address to the VM you wish to connect, and ensure that the port is 22. (Ex. demo@1.2.3.4) This username should match the ‘admin_username’ field populated from the instance.tf file.
