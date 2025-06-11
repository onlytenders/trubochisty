# Build stage
FROM maven:latest AS build
WORKDIR /build

# Copy pom.xml first for dependency caching
COPY pom.xml .

# Use BuildKit cache mount for Maven repository (this is the magic!)
RUN --mount=type=cache,target=/root/.m2 \
    mvn dependency:go-offline -B

# Copy source and build
COPY src ./src

# Build using cached dependencies
RUN --mount=type=cache,target=/root/.m2 \
    mvn clean package -DskipTests

# Runtime stage
FROM amazoncorretto:21-alpine-jdk
WORKDIR /app
COPY --from=build /build/target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]