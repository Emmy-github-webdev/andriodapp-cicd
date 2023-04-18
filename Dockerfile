FROM openjdk:11-jre-alpine

EXPOSE 8080

COPY ./target/andriod-app-*.jar /usr/app/
WORKDIR /usr/app

CMD java -jar andriod-app-*.jar
