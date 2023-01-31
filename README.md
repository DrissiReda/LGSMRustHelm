# Rustserver deployment on Kubernetes using LinuxGSM script


This is a scuffed take on rustserver deployment on Kubernetes. It works on my specific setup. Might not work on yours.


## Docker Image

Build with:

```sh
docker build -t rustserver:0.1 .
```

## Helm install

Make sure you have a `PersistentVolume` ready, or that your cluster is able to deploy them dynamically.


Modify the values to add your own configuration. 


Run a simple `helm install`.


**IMPORTANT**: I need to move the scripts used by cronjobs into configmaps. Currently you're forced to copy them manually from `helm/scripts` into the `.Values.config.scripthome`path if you want to activate them. Same thing for the `rcon` binary into `.Values.config.rconpath`


## Notes

It is possible to use ClusterIP instead of NodePort, if you configure your ingress to forward TCP/UDP ports directly. By default something like nginx ingress will only forward HTTP which doesn't work for our case.

## TODO

- Make sure to have a `readOnlyRootFS`, depends on the work LinuxGSM script do + `update-plugins.sh` optional script.
- Move `rcon` binary into Docker Image.
- Move `helm/scripts` into configmaps.
- Find a better solution for `.Values.config` settings concerning script options.

