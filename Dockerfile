FROM openjdk:8
EXPOSE 8888
VOLUME /tmp
ARG JAR_FILE=target/jwt-auth.war
ADD ${JAR_FILE} jwt-auth.war
ENTRYPOINT ["java", "-jar", "/jwt-auth.war"]
