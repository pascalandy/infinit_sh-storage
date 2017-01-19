### Slack highlights

```
Jan 16th

chris [8:56 AM]  
async causes it to write the blocks to disk an upload them in the background which can make debugging a pain

chris [9:27 AM]  
i don't have team viewer unfortunately :confused:

chris [10:03 AM] 
what replication factor are you using?
pascalandy [10:05 AM] 
what !?!  
I guess it’s the default = 1. Never cared about this at this point

chris [10:05 AM] 
by storage i mean did you specify a storage when creating the network?

chris [10:57 AM] 
node A:
```root@scw-8d211e:~# infinit-doctor --networking -t 50001 -u 50000
Server mode (version: 0.7.2):

To perform tests, run the following command from another node:
> infinit-doctor --networking --tcp_port 50001 --utp_port 50000 --xored_utp_port 50001 --host <address_of_this_machine>```

node B:
```root@scw-2c7150:~# infinit-doctor --networking --tcp_port 50001 --utp_port 50000 --xored_utp_port 50001 --host 10.2.87.219
Client mode (version: 0.7.2):
TCP:
  Upload:
    62ms for 5.2 MB (84.6 MB/sec)
  Download:
    57ms for 5.2 MB (92.0 MB/sec)
UTP:
  Upload:
    1578ms for 5.2 MB (3.3 MB/sec)
  Download:
    528ms for 5.2 MB (9.9 MB/sec)
xored UTP:
  Upload:
    1729ms for 5.2 MB (3.0 MB/sec)
  Download:
    590ms for 5.2 MB (8.9 MB/sec)```
```

### Use infinit-doctor correctly …

```
pascalandy [11:11 AM] 
Holly shit!! I was not doing the test properly!!
    
chris [11:16 AM] 
glad it's working now

chris [8:01 AM] 
it would be better if you use the **package** to install it
pascalandy [8:01 AM] 
Tried but failed!

chris [9:44 AM] 
`--publish` is an alias for `--push-endpoints --fetch-endpoints` or `--push --fetch`. only storage nodes need to push their endpoints to the hub so that other nodes connect to them. all nodes after the first node should fetch

it's safe to just use `--publish` for all the nodes though
```

### Capacity

```
pascalandy [9:49 AM] 
about --capacity ...
I tought we had to define this

chris [9:50 AM] 
you don't need to specify that, it's an optional limit on how much storage you'd like to contribute to the cluster

chris [11:01 AM] 
basically we store all the data in a DHT. the first time you run the volume (on any node), we want to write a root block that contains the information about the `/` directory. there's no sure way to check that the block hasn't been created before because you might not be connected to the storage node that has it or for another reason

so we use that flag to ensure that you only write the root block once
```

### --publish means ?

``` 
as i said before, `--publish` is really just an alias for `--push --fetch`. in this case the push will be ignored

pascalandy [4:24 PM] 
Two things:
1)
my  mountpoint is: /root/mnt/infinit/dev-h

While I was copying file from mysql, I saw those issues. Can we consider them normal?

--async is not used at this point

'/root/mnt/infinit/dev-h/is-workdir/mysql/mysqltmp/ibdata1' -> '/root/mnt/infinit/dev-h/is-workdir/mysqltmp/ibdata1'
'/root/mnt/infinit/dev-h/is-workdir/mysql/mysqltmp/ib_logfile0' -> '/root/mnt/infinit/dev-h/is-workdir/mysqltmp/ib_logfile0'
[infinit.overlay.kelips] [generator] Kelips(0.0.0.0:0): Timeout on PUT attempt 0
[infinit.overlay.kelips] [generator] Kelips(0.0.0.0:0): Timeout on PUT attempt 0
[infinit.overlay.kelips] [generator] Kelips(0.0.0.0:0): Timeout on PUT attempt 0
[infinit.overlay.kelips] [generator] Kelips(0.0.0.0:0): Timeout on PUT attempt 0
[infinit.overlay.kelips] [generator] Kelips(0.0.0.0:0): Timeout on PUT attempt 0
[infinit.overlay.kelips] [generator] Kelips(0.0.0.0:0): Timeout on PUT attempt 0
[infinit.overlay.kelips] [generator] Kelips(0.0.0.0:0): Timeout on PUT attempt 0
[infinit.overlay.kelips] [generator] Kelips(0.0.0.0:0): Timeout on PUT attempt 0
[infinit.overlay.kelips] [generator] Kelips(0.0.0.0:0): Timeout on PUT attempt 0
[infinit.overlay.kelips] [generator] Kelips(0.0.0.0:0): Timeout on PUT attempt 0
[infinit.overlay.kelips] [generator] Kelips(0.0.0.0:0): Timeout on PUT attempt 0

2)
Node 2:
I did test to copy-paste a folder and double check it’s size:

$ du -sh /root/mnt/infinit/dev-h/is-workdir/mysql
> 875M 

$ du -sh /root/mnt/infinit/dev-h/is-workdir/mysqltmp
> 875M    

 
I see the same result on Node1 and Node 3. At this point I assume that everything works as expected.

But, when I do:
$ infinit-doctor --all

CONFIGURATION INTEGRITY:
[OK] Storage resources
[OK] Networks
[OK] Volumes
[OK] Drives
[OK] Leftovers

SYSTEM SANITY:
[OK] Username
[OK] Space left
[WARNING] Environment:
  INFINIT_USER: pascal
  Reason: your environment contains variables that will modify Infinit default behavior. For more details visit https://infinit.sh/documentation/environment-variables
[OK] Permissions
[OK] FUSE

CONNECTIVITY:
[OK] Connection to https://beyond.infinit.sh
[OK] Local interfaces
[OK] Nat
[ERROR] UPNP:
  Reason: UPNP device discovery failure: 0
[OK] Protocols


I get this [ERROR] UPNP:

So I’m not so confident now.
```

### message errors

```
chris [3:35 AM
for 1) it's not completely unexpected. kelips uses UDP which can have packet loss

pascalandy [7:28 AM] 
I’m surprise by this. Most infinit_sh users are using cloud servers right?

chris [7:29 AM] 
we don't know where we are running so we can only test everything

it's not really an error so much as a warning that if you have an issue it may be caused by this

pascalandy [7:29 AM] 
Just to be sure, your consider this a warning ?
[ERROR] UPNP: (edited)

chris [7:41 AM] 
it should be working now. we are looking at adding some form of monitoring but since the system is decentralised it's not that straightforward
```

### --async

```
pascalandy [8:16 AM] 
Cool.
I get it. It might be problematic for huge files.
> depending on what you're doing, async might not be ideal. it stores changes locally and then saves them to the storage nodes in the background
chris [8:17 AM] 
yes, for big files, it will fill the local disk
pascalandy [8:17 AM] 
yep

chris [8:17 AM] 
there are also cases that you could lose data

[8:17]  
or that you will not see changes when you expect them across nodes

[8:17]  
in general i prefer to not use --async as then i know the changes have taken place

pascalandy [8:19 AM] 
Damm Chris …
```

### my use case

```
[8:20]  
Actually, going back about why I want a tool like Infinit.

[8:20]  
I want something simple as dropbox for my servers.

[8:20]  
But I don’t need a 3td party to host the data

[8:21]  
My cluster will always have at least 3 nodes

[8:21]  
This is the core piece

[8:22]  
Then when this system is rock solid, I’ll have cron synching the share folder to storage object like S3

[8:22]  
So I’m not sure I can count on Infinit at this point.
```

### Replication Factor !!

```
(default is 1, I think it should be an explicit value)

pascalandy [8:52 AM] 
I guess --replication-factor 3 would be best practice

[8:53]  
I’ll have more than 3 nodes in the future so it sounds great

chris [8:53 AM] 
uneven numbers of replication are better
so yes, 3 would be better
```

### What the hell ?

```
chris [11:51 AM] 
the syntax is correct

[11:51]  
the issue is that you don't have the network on that node

[11:51]  
if you do `infinit-network --list` you will see that

pascalandy [11:52 AM] 
make sense … but you see my commands

chris [12:02 PM] 
according to that there is already a network on the hub (edited)

pascalandy [12:02 PM] 
yep

chris [12:02 PM] 
actually locally

[12:02]  
not necessarily on the hub

pascalandy [12:02 PM] 
oh!

pascalandy [12:07 PM] 
like this?
infinit-network --push --name $NETWORK_NAME

[12:07]  
Looks good:

root@N01-par1:~/mnt/infinit/dev-h# infinit-network --push --name $NETWORK_NAME
Remotely saved network "pascal/inf_network".

[12:08]  
It worked!

chris [12:10 PM] 
you should stop the script on errors
```

### Jan 19th

```
pascalandy [11:12 PM] 
Files are synching normally but the infinit.overlay.kelips messages are overwhelming. They take over my systems.
```

### Kouncil overlay !!

```
chris [12:04 PM] 
afternoon! you can either redirect the messages from stderr or you can try the Kouncil overlay
**kouncil is designed to be more efficient for smaller clusters**

pascalandy [12:12 PM] 
OK, so if re-create a cluster I will be able to use kouncil this way:

```infinit-network --create $NETWORK_NAME --kouncil ‑‑admin-rw $INFINIT_USER --storage $STORAGE_NAME --replication-factor 3; sleep 1; echo;```

pascalandy [12:14 PM] 
Good. What do you mean my ‘smaller’ cluster ?

chris [12:14 PM] 
tens of nodes
kelips is designed to handle thousands
http://iptps03.cs.berkeley.edu/final-papers/kelips.pdf
we will be changing the default overlay from kelips to kouncil in the next release
```

### Up to now

At this moment I export https://github.com/pascalandy/infinit_sh-storage/commit/6b83b8c2b35ed848cfef8e862f50408424baa236

Hope it helped :)

Pascal
https://twitter.com/_pascalandy