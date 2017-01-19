SECTION B:
by Pascal Andy, https://twitter.com/_pascalandy

# Copy-paste VARs (All nodes) — — — — — — — — — — — — — — — — #

CLUSTER_VERSION="a"
CLUSTER_ROLE="dev"
CLUSTER_NAME="$CLUSTER_ROLE-$CLUSTER_VERSION"
#
USER_NAME=myuserdaddy
NETWORK_NAME=inf_network
STORAGE_NAME=local
VOLUME_NAME=$CLUSTER_NAME
MOUNT_PATH=~/mnt/infinit/$CLUSTER_NAME
#
export INFINIT_USER=$USER_NAME
#
echo
echo "$USER_NAME < USER_NAME"
echo "$INFINIT_USER < INFINIT_USER"
echo "$CLUSTER_NAME < CLUSTER_NAME"
echo "$NETWORK_NAME < NETWORK_NAME"
echo "$STORAGE_NAME < STORAGE_NAME"
echo "$VOLUME_NAME < VOLUME_NAME"
echo "$MOUNT_PATH < MOUNT_PATH"


### Node 1 — — — — — — — — — — — — — — — — #

### Create a new user
# Creating a user with infinit is like creating an email account. You have it for life.
# ie infinit-user --signup --name russ --fullname "Russ McKendrick"
# https://media-glass.es/playing-with-infinit-docker-651236e68cf#.2z7jqy5n8

### Import existing user
# Of course you previously created and exported your user
rm -rf ~/temp; mkdir -p ~/temp; cd ~/temp; ls -la;
cat <<< '{"fu...... ......... ...........6hs46rht"}}' > ~/temp/$USER_NAME.user
cat ~/temp/$USER_NAME.user; sleep 1; echo;

# First we're going to completely clean the Hub.
# Pull the user, all networks and all volumes that the user owns.
# We do this to make sure it's less confusing when we try to debug.

infinit-user --import --input ~/tmp/$USER_NAME.user; sleep 1; echo;
infinit-user --pull --purge $USER_NAME --as $USER_NAME; sleep 1; echo;
# Set up infrastructure
infinit-user --push; sleep 1; echo;
