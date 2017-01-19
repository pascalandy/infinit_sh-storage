SECTION A:
by Pascal Andy, https://twitter.com/_pascalandy

Installation > see 2-config-scale.sh




### Installation https://infinit.sh/get-started/linux

### Export the user we would like to use
export INFINIT_USER=myuserdaddy

sudo apt-get -y update
sudo apt-get install -qy fuse
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3D2C3B0B
sudo apt-get install -qy software-properties-common apt-transport-https
sudo apt-add-repository -y "deb https://debian.infinit.sh/ trusty main"
sudo apt-get -y update
sudo apt-get install -qy infinit

### Removing PPA (it mess around apt-get udpate)
sudo add-apt-repository --remove "deb https://debian.infinit.sh/ trusty main"

### Install psmisc so that we have the `killall` command
sudo apt-get install -qy psmisc

### Update the `PATH` to include the Infinit binaries
export PATH=/opt/infinit/bin:$PATH

# Permanently set $PATH
echo "" >> ~/.profile
echo "" >> ~/.profile
echo "### ### ### ### ### ### ### ### ### ###" >> ~/.profile
echo "" >> ~/.profile
echo "" >> ~/.profile
echo "### Adding infinit in our PATH" >> ~/.profile
echo "PATH=$PATH:/opt/infinit/bin" >> ~/.profile

### Test the installation
cd /opt/infinit/bin && ls -la
echo "Unit-test. We should see infinit version here:"
infinit-user -v