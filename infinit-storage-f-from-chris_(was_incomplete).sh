# from Chris Crone 
# Follow my trial and error here: https://gist.github.com/pascalandy/21c262ce9e7b6b240badf8b3b7a4c18d/


### All nodes:
# Follow repository install on https://infinit.sh/get-started/linux
# Install psmisc so that we have the `killall` command
apt-get install psmisc
# Export the user we would like to use.
export INFINIT_USER=pascal
# Update the `PATH` to include the Infinit binaries.
export PATH=/opt/infinit/bin:$PATH

### Node 1:
# First we're going to completely clean the Hub.
# The command will pull the user, all networks and all volumes that the user owns.
# We do this to make sure it's less confusing when we try to debug.
infinit-user --import pascal.user
infinit-user --pull --purge pascal --as pascal
# Set up infrastructure.
infinit-user --push

infinit-storage --create local
infinit-network --create my-network --storage local --push
infinit-volume --create my-volume --network my-network --push
# Mount the volume.
infinit-volume --run my-volume -m ~/mnt --cache --push --daemon
# Check that the volume works as expected. Stop and debug if it does not.
ls ~/mnt
touch ~/mnt/something
ls ~/mnt
# Transmit user for Node 2.
infinit-device --transmit --user

### Node 2:
# Fetch infrastructure.
infinit-device --receive --user
infinit-network --fetch
infinit-network --link my-network
infinit-volume --fetch
# Check volume is working.
infinit-volume --run my-volume -m ~/mnt --cache --fetch --daemon
ls ~/mnt

### Node 3:
# Transmit user again and follow steps for node 2.

### Clean up (node 2 and 3):
killall infinit-volume
rm -rf ~/.local/share/infinit

### Clean up (node 1):
killall infinit-volume
infinit-user --pull --purge pascale
rm -rf ~/.local/share/infinit