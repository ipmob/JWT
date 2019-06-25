### Steps for running the docker file:

### from root of the project " $jwt "
#### 1.
*build the project through termnal  mvn clean package / mvn package 
* or 
* build it through intellij  maven[install]


#### 2.
* after the packaging the project go to terminal
* nevigate to the root of the project ( cd  path/jwt )
 
#### 3. check docker is properly installed

* sudo docker ps
* then run :

## 4.
sudo docker build -t jwt .
** don't forget the " . "

## then run the docker image

sudo docker run -p 8888:8888 jwt


 


