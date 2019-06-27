## Steps for running the docker file:

### Install Docker First 
here is a resource that helped me out
( https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04 ) 



### from root of the project " $jwt "
#### 1.
*build the project through termnal   
>> mvn clean package
or 
>> mvn package 
* or 
* build it through intellij  
>> maven[clean install]
or
>> maven[install]


#### 2.
* after the packaging the project go to terminal
* nevigate to the root of the project ( $ cd  path/jwt )  ** Really Important **
 
#### 3. check docker is properly installed

>> sudo docker ps

** it will present output in form of **
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES


#### 4.
>> sudo docker build -t jwt .


** don't forget the " . " **

// it will take sometime for downloading and building the image. //

#### then run the docker image

>> sudo docker run -p 8888:8888 jwt


 


