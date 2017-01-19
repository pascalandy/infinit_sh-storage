SECTION E:
by Pascal Andy, https://twitter.com/_pascalandy



### Export a user (Save the output outside the server and delete the file)
infinit-user --export --full --name pascal --output pascal.user
	
# — — — — — — — — — — — — — — — — #
### To Scrap infinit 
# Clean up (node 2 and 3):
killall infinit-volume
rm -rf ~/.local/share/infinit

# Clean up (node 1):
killall infinit-volume
infinit-user --pull --purge pascal
rm -rf ~/.local/share/infinit

# — — — — — — — — — — — — — — — — #
### Test connectivity between 2 nodes:
# Node A


PRIVATE_IP=$(ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1) && echo "$PRIVATE_IP"
infinit-doctor --networking

# Node B
infinit-doctor --networking --tcp_port 37501 --utp_port 48202 --xored_utp_port 46765 --host $IP_NODE_A

infinit-doctor --networking --tcp_port 38119 --utp_port 41204 --xored_utp_port 53975 --host 10.2.175.25


#END



# — — — — — — — — — — — — — — — —

### On OSX (do not use --deamon)
#infinit-volume --mount --as pascal --name dev_e --mountpoint ~/mnt/infinit/dev_e --allow-root-creation --async --cache --publish

cd ~/mnt/infinit/$CLUSTER_NAME
df -h ~/mnt/infinit/$CLUSTER_NAME
ls -lhat ~/mnt/infinit/$CLUSTER_NAME
echo
cat ~/mnt/infinit/$CLUSTER_NAME/fromN01.txt
echo
echo "Test2 - 2017-01-16_12h12" >> ~/mnt/infinit/$CLUSTER_NAME/fromN11.txt
cat ~/mnt/infinit/$CLUSTER_NAME/fromN11.txt




### ### ### ### ### ### ### ### ### ###
## Docker Plugin
### ### ### ### ### ### ### ### ### ###

# NOT tested yet
echo "user_allow_other" >> /etc/fuse.conf
infinit-daemon --start --as mrandy --docker-user root
docker volume list

docker run -d --volume-driver infinit -v mrandy/dev_e:/mnt alpine sh

docker run -it --rm --volume-driver infinit -v mrandy/dev_e:/data alpine sh




### ### ### ### ### ### ### ### ### ###
## Installation OSX
### ### ### ### ### ### ### ### ### ###

brew cask install osxfuse
brew install infinit/releases/infinit
	# To install homebrew all need stuff on your Mac > https://goo.gl/P4OJnI
	
Then, see instructions for Node 2

	### On OSX (do not use --deamon)
	#infinit-volume --mount --as pascal --name dev_e --mountpoint ~/mnt/infinit/dev_e --allow-root-creation --async --cache --publish

cd ~/mnt/infinit/$CLUSTER_NAME
df -h ~/mnt/infinit/$CLUSTER_NAME
ls -lhat ~/mnt/infinit/$CLUSTER_NAME
echo
cat ~/mnt/infinit/$CLUSTER_NAME/fromN01.txt
echo
echo "Test2 - 2017-01-16_12h12" >> ~/mnt/infinit/$CLUSTER_NAME/fromN11.txt
cat ~/mnt/infinit/$CLUSTER_NAME/fromN11.txt
