
#!/bin/bash

printf "############################################################################
# start minikube
minikube start

# open dashboard in browser
minikube dashboard

# deploy a sample kubernetes 'deployment' to the local minikube
kubectl create deployment hello-minikube --image=gcr.io/google_containers/echoserver:1.4

# expose this deployment to an external network
kubectl expose deployment hello-minikube --type=LoadBalancer --port=8080

# access deployment in browser
minikube ip
open the address in a browser and go to port 8080

# access the service and print the reply
curl\$(minikube service hello-minikube --url)

# delete the service
kubectl delete service hello-minikube

# delete the deployment
kubectl delete deployment hello-minikube

# stop minikube
minikube stop
"