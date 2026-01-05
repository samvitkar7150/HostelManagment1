# Stage 1: Build with Maven 3.9.12
FROM maven:3.9.12-eclipse-temurin-11 AS build

WORKDIR /app

# Copy pom.xml first to leverage Docker cache
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:11-jre

WORKDIR /app

# Copy the built jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Change this to the port your app uses
EXPOSE 7070

ENTRYPOINT ["java", "-jar", "app.jar"]

