FROM openjdk:11-jre-alpine
EXPOSE 8080
COPY ./build/libs/andriod-app-1.0-SNAPSHOT.jar /usr/app/
WORKDIR /usr/app
ENTRYPOINT [ "java", "-jar", "andriod-app-1.0-SNAPSHOT.jar" ]