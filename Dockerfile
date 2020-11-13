FROM openjdk:8-jdk-alpine as build

ENV MAVEN_VERSION 3.5.4
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

RUN ["mkdir","-p","/app"]
RUN ["chmod","777","/var"]
RUN ["chmod","777","/var/log"]
WORKDIR /app
COPY mvnw ./mvnw
COPY .mvn ./.mvn
COPY pom.xml ./pom.xml
COPY src ./src
RUN  mvn clean package

FROM openjdk:8-jdk-alpine
ARG DEP=/app/target
COPY --from=build ${DEP}/AWSCoronaWebpage-0.0.1-SNAPSHOT.war /app/app.war
EXPOSE 8080
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app/app.war"]
