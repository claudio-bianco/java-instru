#
# Build stage
#
FROM maven:3.6.0-jdk-11-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

#
# Package stage
#
FROM adoptopenjdk/openjdk11:alpine-jre
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
WORKDIR /opt/app
COPY --from=build /home/app/target/*.jar /opt/app/demo.jar
ENTRYPOINT ["java","-jar","/opt/app/demo.jar"]