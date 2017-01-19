SECTION D:
--replication-factor 3
	# https://infinit.sh/documentation/deployments#distributed-server-1
	
by Pascal Andy, https://twitter.com/_pascalandy




# Node #1
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #

# Setup volume
echo;
infinit-storage --create $STORAGE_NAME; sleep 1; echo;
infinit-network --create $NETWORK_NAME --storage $STORAGE_NAME --kouncil --replication-factor 3; sleep 1; echo;
infinit-network --push --name $NETWORK_NAME; sleep 1; echo;
infinit-volume --create $VOLUME_NAME --network $NETWORK_NAME; sleep 1; echo;
infinit-volume --push --name $VOLUME_NAME; sleep 1; echo;
mkdir -p $MOUNT_PATH; cd $MOUNT_PATH; pwd; ls -la; sleep 1; echo;
infinit-volume --run $CLUSTER_NAME -m $MOUNT_PATH --async --cache --allow-root-creation --publish --daemon; sleep 1; echo;

	# infinit-network --create $NETWORK_NAME --storage $STORAGE_NAME --kouncil --replication-factor 3 ‑‑admin-rw $INFINIT_USER; sleep 1; echo; 
	
# Test & create a dummy text file
FROM_NODE=N12;
echo;
cd $MOUNT_PATH; pwd; ls -la; sleep 1; echo;
WHEN="$(date +%Y-%m-%d_%H-%M-%S)";
echo "Created from $FROM_NODE - $WHEN" >> $MOUNT_PATH/$FROM_NODE.txt
ls -la; cat $MOUNT_PATH/$FROM_NODE.txt; echo;

# Test & create a dummy file of X Mo
FILE_SIZE=7M
echo; cd $MOUNT_PATH; pwd; ls -la; sleep 1; echo;
WHEN="$(date +%Y-%m-%d_%H-%M-%S)";
dd if=/dev/zero of="$FROM_NODE"_"$WHEN".dat  bs=$FILE_SIZE  count=1
ls -la; echo;

	# From Node 1, transmit user on a another node
	# Generate a fancy passphrase
	#STEP1=$((RANDOM%63246+42562))
	#STEP2=$(openssl rand -base64 $STEP1)
	#STEP3=$(echo -n "$STEP2" | shasum -a 512 | head -c 45)
	#echo "Here is a fancy passphrase: $STEP3" && echo
	
infinit-device --transmit --user; sleep 1; echo;
	# 27be3c7f1950e11f2b3c2d56fa47f5bb1bbde2f5795fc


# Node #2
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #

Copy-paste ENV_VARs
 Copy-paste ENV_VARs
  Copy-paste ENV_VARs
#
infinit-device --receive --user; sleep 1; echo;

infinit-network --fetch; sleep 1; echo;
infinit-storage --create --name $STORAGE_NAME; sleep 1; echo;
infinit-network --link $NETWORK_NAME --storage $STORAGE_NAME; sleep 1; echo;
infinit-volume --fetch; sleep 1; echo;
mkdir -p $MOUNT_PATH; cd $MOUNT_PATH; pwd; ls -la; sleep 1; echo;
infinit-volume --run $CLUSTER_NAME -m $MOUNT_PATH --async --cache --fetch --publish --daemon; sleep 1; echo;

# Test & create a dummy text file
FROM_NODE=N11;
echo;
cd $MOUNT_PATH; pwd; ls -la; sleep 1; echo;
WHEN="$(date +%Y-%m-%d_%H-%M-%S)";
echo "Created from $FROM_NODE - $WHEN" >> $MOUNT_PATH/$FROM_NODE.txt
ls -la; cat $MOUNT_PATH/$FROM_NODE.txt; echo;

# Test & create a dummy file of X Mo
FILE_SIZE=8M
echo; cd $MOUNT_PATH; pwd; ls -la; sleep 1; echo;
WHEN="$(date +%Y-%m-%d_%H-%M-%S)";
dd if=/dev/zero of="$FROM_NODE"_"$WHEN".dat  bs=$FILE_SIZE  count=1
ls -la; echo;


# Node #3
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #

Follow the same process as for Node 2

# Test & create a dummy text file
FROM_NODE=N01;
echo;
cd $MOUNT_PATH; pwd; ls -la; sleep 1; echo;
WHEN="$(date +%Y-%m-%d_%H-%M-%S)";
echo "Created from $FROM_NODE - $WHEN" >> $MOUNT_PATH/$FROM_NODE.txt
ls -la; cat $MOUNT_PATH/$FROM_NODE.txt; echo;

# Test & create a dummy file of X Mo
FILE_SIZE=9M
echo; cd $MOUNT_PATH; pwd; ls -la; sleep 1; echo;
WHEN="$(date +%Y-%m-%d_%H-%M-%S)";
dd if=/dev/zero of="$FROM_NODE"_"$WHEN".dat  bs=$FILE_SIZE  count=1
ls -la; echo;





# Remove the file used to imported our user on Node 1
rm -rf ~/temp; mkdir -p ~/temp; cd ~/temp; ls -la;


# Check asynchronous network cache
infinit-journal --stat --network $NETWORK_NAME