
#!/bin/bash

printf "############################################################################
kubectl get <type name>                      lists all instances of deployments, pods, services or other resources
kubectl get <type name> <identifier>         gives a short summary of the specified item

kubectl describe <type name>                 describes detailed information about all items of that type
kubectl describe <type name> <identifier>    describes detailed information about a specific item

kubectl create <type name> <identifier>      general command for creating items. required arguments depend on item type
[--image=<image>]                            to create a deployment, you need an image
[-f <yaml file>]                             you can also create a deployment from a yaml file

kubectl apply <type name> <identifier>       same as 'create', but used to modify already existing items

kubectl expose <type name> <identifier>      exposes a port for a given deployment, pod, or other resource
[--port=external port]
[--target-port=container port]
[--type=service type]

kubectl port-forward <pod> <remote port>     forward one or more local ports to a pod
[<local port>:<remote port>]                 the local port argument is optional

kubectl attach <pod name>                    attaches to a running container to view the output stream or interact with it
[-c <container>]                             specify a container inside the pod, when the pod has multiple containers

kubectl exec <pod name> <command>            execute a command in a container (use 'bash' as a command to open a shell)
[-it]                                        open an interactive tty in the container (same as docker)
[-c <container>]                             specify a container inside the pod

for more detailed info:
https://kubernetes.io/docs/reference/kubectl/overview/
https://kubernetes.io/docs/reference/kubectl/cheatsheet/
"