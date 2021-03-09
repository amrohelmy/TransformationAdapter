## Code build and test container ##

FROM maven:3-jdk-14 as builder

WORKDIR '/TransformationAdapter'

COPY ./ ./

RUN mvn clean install

###############################

## Code deploy container ##

FROM openjdk:8-jdk-alpine

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring


WORKDIR '/TransformationAdapter'

COPY --from=builder /TransformationAdapter/target/*.jar app.jar

CMD ["java","-jar","app.jar"]