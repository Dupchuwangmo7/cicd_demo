# Multi-stage build for better security and smaller image size
# Stage 1: Build stage (not needed since we're copying pre-built JAR, but shown for best practice)
FROM eclipse-temurin:17-jdk-jammy AS builder
WORKDIR /build
# If building from source, uncomment these lines:
# COPY pom.xml .
# COPY src ./src
# RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime stage with minimal and secure base image
FROM eclipse-temurin:17-jre-jammy

# https://medium.com/@skywalkerhunter/aws-docker-deploy-spring-boot-fe05a00191d9
# added on 31st Oct
LABEL maintainer="Darryl Ng <darryl1975@hotmail.com>"
LABEL description="Dockerfile for deploying to Beanstalk needs dockerrun.aws.json"

# Create a non-root user for security
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Update system packages and install security updates, install curl for healthcheck
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory to /app
WORKDIR /app

# Change ownership of the app directory to the non-root user
RUN chown -R appuser:appuser /app

# Copy the Spring Boot application JAR file into the Docker image
COPY --chown=appuser:appuser target/cicd-demo-0.0.1-SNAPSHOT.jar /app/cicd-demo-0.0.1-SNAPSHOT.jar

# Switch to non-root user
USER appuser

# added on 31st Oct
#COPY target/cicd-demo-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/cicd-demo-0.0.1-SNAPSHOT.war

# Set environment variables
#ENV SERVER_PORT=5000
# ENV LOGGING_LEVEL=INFO

# Expose the port that the Spring Boot application is listening on
EXPOSE 5000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/actuator/health || exit 1

# Run the Spring Boot application when the container starts
CMD ["java", "-jar", "cicd-demo-0.0.1-SNAPSHOT.jar"]

# added on 31st Oct
# ENTRYPOINT [ "sh", "-c", "java -Dspring.profiles.active=prod -jar /usr/local/tomcat/webapps/cicd-demo-0.0.1-SNAPSHOT.war" ]