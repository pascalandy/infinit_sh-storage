SECTION C:
--replication-factor 1 (default)
by Pascal Andy, https://twitter.com/_pascalandy

WARNING it's not well tested. See infinit-storage-d.sh instead








### Node 1:

# Setup volume
infinit-storage --create $STORAGE_NAME
infinit-network --create $NETWORK_NAME --storage $STORAGE_NAME --push
infinit-volume --create $VOLUME_NAME --network $NETWORK_NAME --push
# Mount the volume
mkdir -p $MOUNT_PATH
infinit-volume --run $CLUSTER_NAME -m $MOUNT_PATH --async --allow-root-creation --cache --publish --daemon

# Check that the volume works as expected. Stop and debug if it does not.
cd $MOUNT_PATH && ls
echo "Test from Node 1" >> $MOUNT_PATH/test1.txt
cat $MOUNT_PATH/test1.txt && ls

# Remove the file used to imported our user
rm -rf ~/tmp
cd $MOUNT_PATH && ls

# From Node 1, transmit user on a another node
# Generate a fancy passphrase
STEP1=$((RANDOM%63246+42562))
STEP2=$(openssl rand -base64 $STEP1)
STEP3=$(echo -n "$STEP2" | shasum -a 512 | head -c 45)
echo "Here is a fancy passphrase: $STEP3"

infinit-device --transmit --user



# — — — — — — — — — — — — — — — — #
### Node 2:

Ensure you copied-paste VAR seen above
#
infinit-device --receive --user

infinit-network --fetch
infinit-storage --create --name $STORAGE_NAME
infinit-network --link $NETWORK_NAME --storage $STORAGE_NAME
infinit-volume --fetch
# Mount the volume
mkdir -p $MOUNT_PATH
infinit-volume --run $CLUSTER_NAME -m $MOUNT_PATH --async --cache --fetch --publish --daemon


# Check that the volume works as expected. Stop and debug if it does not.
cd $MOUNT_PATH && ls
echo "Test from Node 2" >> $MOUNT_PATH/test2.txt
cat $MOUNT_PATH/test2.txt && ls
# Re-check on Node 1, you will see test2.txt :)



# — — — — — — — — — — — — — — — — #
### Node 3:
Follow the same process as for Node 2

# Check that the volume works as expected. Stop and debug if it does not.
cd $MOUNT_PATH && ls
echo "Test from Node 3" >> $MOUNT_PATH/test3.txt
cat $MOUNT_PATH/test3.txt && ls
# Re-check on Node 1, you will see test3.txt :)