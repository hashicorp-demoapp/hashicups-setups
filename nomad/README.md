# Nomad Setup

This deploys HashiCups to a Nomad cluster running locally or remotely.

It does not require Consul or any other mesh tool for service discovery but instead uses static ports for communication between services. 

## Deploying HashiCups
There are two ways of deploying HashiCups on Nomad: manually with the [job file](hashicups.nomad) and automatically with [Nomad Pack](https://github.com/hashicorp/nomad-pack#nomad-pack).

## With the Job File
Make sure your `NOMAD_ADDR` environment variable is set to your cluster's address.

```
export NOMAD_ADDR=<CLUSTER_ADDRESS>:4646
```

If you have ACLs enabled, make sure to set the `NOMAD_TOKEN` variable too.

```
export NOMAD_TOKEN=<ACL_TOKEN_VALUE>
```

From this directory, run the job file.

```
nomad job run hashicups.nomad
```

### Cleanup
Stop the job with the following command.
```
nomad job stop hashicups
```

Add the `-purge` flag to remove it from the system entirely (won't show up in the UI, etc).

```
nomad job stop -purge hashicups
```

## With Nomad Pack
Make sure that you have [Nomad Pack installed](https://github.com/hashicorp/nomad-pack#installation) and your Nomad environment variables set (`NOMAD_ADDR` and `NOMAD_TOKEN` if using ACLs).

Run the `hashicups` job from the `community` registry.

```
nomad-pack run hashicups --registry=community
```

### Cleanup
Stop the job with the following command.
```
nomad-pack stop hashicups
```

The `destroy` command will stop the job and remove it from the system entirely (won't show up in the UI, etc).

```
nomad-pack destroy hashicups
```

## Local Cluster Notes

### Docker Desktop
If you are running Nomad on your local machine with Docker Desktop, you'll need to bind the Nomad client to a non-loopback network interface so that the containers can communicate with each other.

```
$ nomad agent -dev -bind=0.0.0.0 -network-interface=en0
```

This will bind to the `en0` interface. You can retrieve the IP address associated with it by inspecting the interface and looking at the line starting with `inet`.

```
$ ifconfig
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	options=400<CHANNEL_IO>
	ether 88:66:5a:44:34:e8 
	inet6 fe80::c5c:1de8:d154:9341%en0 prefixlen 64 secured scopeid 0x6 
	inet 192.168.1.6 netmask 0xffffff00 broadcast 192.168.1.255
	nd6 options=201<PERFORMNUD,DAD>
	media: autoselect
	status: active
```

With the above configuration, the Nomad UI can be accessed at `192.168.1.6:4646` and the HashiCups UI can be accessed with the same IP address on port `80` by default.

See [this FAQ page](https://www.nomadproject.io/docs/faq#q-how-to-connect-to-my-host-network-when-using-docker-desktop-windows-and-macos) for more information.

### Accessing the UI Locally
To get the IP address of where the services are running, first find the allocation ID for the hashicups job (this command will find just the allocation information).

```
nomad job status hashicups | grep -A 3 -i allocations 
```
```
Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created    Modified
b16fc004  6a7efee4  hashicups   21       run      running  1h59m ago  1h59m ago
```

Then use the allocation ID from the output above to list the service addresses (this command will just print out the allocation addresses).

```
nomad alloc status b16fc004 | grep -A 8 -i allocation
```
```
Allocation Addresses
Label          Dynamic  Address
*db            yes      192.168.1.6:5432
*product-api   yes      192.168.1.6:9090
*frontend      yes      192.168.1.6:3000
*payments-api  yes      192.168.1.6:8080
*public-api    yes      192.168.1.6:8081
*nginx         yes      192.168.1.6:8045
```

Access the UI by navigating to the `nginx` address.