# Tory
Tory helps you inventory (get it?) your organization's computers. It also serves as a basic frontend to PXE and Clonezilla for disk imaging.

### Status

The development status of this project is beta at best, but probably alpha. Meaning, most of the main features are set but only mildly tested. 

Currently Tory the Rails app (this) uses the `net-ssh` and `net-sftp` libraries to create PXE tasks on remote servers. This works, but is slow, requires a "pxe" user on the remote machine, and is prone to stuff going wrong.

Legacy server limitations forced the SSH model, but originally I implemented a client/server model over HTTP. This worked better, and I will change back to that soon.