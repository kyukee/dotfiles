
#!/bin/bash

printf "############################################################################
docker ps                       list only running containers
-a                              list all containers

docker rm \$container            remove container from history

docker images                   list all images

docker rmi \$image               remove image

docker build \$dockerfile_path   build an image from a dockerfile ('.' for current directory)
-t \$tag                         give the image a name (ideal format: \$dockerhub_user / \$image_name : \$tag)

docker push \$tag                push an image to docker hub (ideal format: \$dockerhub_user/\$name:\$tag)

docker run \$image               start a container from an image
--name \$name                    run container with a certain name
-it                             essentialy ssh into the container
-d                              detatched mode (runs in background)
-p \$host_port:\$contnr_port      redirect ports (expose ports)
-v \$host_path:\$contnr_path      mount a volume (shared folders) (needs to be full path)
\${PWD}                          can be used in -v to indicate current directory

docker attach \$container        essentialy ssh into an already running container

exit                            exit out of a container's shell
ctrl+p , ctrl+q                 exit out of a container's shell, while keeping the process running

docker start \$container         start a not running container
docker stop \$container          stop a running container

docker kill \$container          use kill instead of stop if the container is unresponsive

docker exec \$container \$process start a new process in an already running container
-it                             essentialy ssh into the container

docker inspect \$item            display image or container information
| grep IPAddress                use grep to filter the information              
"