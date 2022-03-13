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

	$ chmod +x *.sh
	$ aws configure

	Paste Access Key ID
	Paste Secret Access Key

	The rest remains empty.


9.	Run the installation.
	$ ./install.sh


10.	Clone images into new "Free tier eligible" instances and run all of them.
	The parameter defines the number of new instances.
	$ ./cloneTemplates.sh 15


11.	Make the fire to targets defined as parameter
	$ ./fire.sh https://tass.ru/ http://www.tinkoff.ru/ https://www.tinkoff.ru/


##	To stop the fire (kill and remove docker instances), use
	$ ./killAll.sh


##	To remove all AWS instances, use
	$ ./terminateInstances.sh


##	To remove everything incl. instances, AMI images, Security groups and Key Pairs, use
	$ ./wipe.sh
