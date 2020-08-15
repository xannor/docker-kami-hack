# docker-kami-hack

The repository is maintained at <https://github.com/xannor/docker-kami-hack/>

**WORK IN PROGRESS**

This docker image provides a development environment for the [Hack for Kami(YI) cameras ](https://github.com/xannor/kami-hack-MStar) which is maintained by @xannor. All the necessary tools to build the project are provided by this docker image. Thanks to @borodilliz for the origional repo for the original [docker-yi-hack](https://github.com/borodolliz/docker-yi-hack) for the Yi MStar cameras.
    
## Usage

1. Prepare your .ssh directory. You should provide the .ssh directory that will be used in the container. As an example, you should add your public ssh key to your authorized_keys:

    cat ~/.ssh/id_rsa.pub >>  ~/.ssh/authorized_keys

2. Clone [xannor/kami-hack-MStar](https://github.com/xannor/kami-hack-MStar) 

    git clone https://github.com/xannor/kami-hack-MStar.git

3. Run docker container (set ssh port and paths to your needs)

    docker run -d \
    -v ~/kami-hack-MStar:/yi-hack-src \  
    -v ~/.ssh:/root/.ssh \
    -p 2225:22 \ 
    xannor/kami-hack:latest 
    
4. Connect to docker container using SSH

    ssh root@localhost -p 2225
    
4. Start coding!

    cd /yi-hack-src # And start coding!

## Build image yourself (instead of using dockerhub)

1. Clone this repository

    git clone https://github.com/xannor/docker-kami-hack

2. Build and tag a new docker image
    
    docker image build -t my-kami-hack:latest .

3. Run a new container

    docker run -d \
    -v ~/kami-hack-MStar:/yi-hack-src \  
    -v ~/.ssh:/root/.ssh \
    -p 2225:22 \ 
    my-kami-hack:latest 
