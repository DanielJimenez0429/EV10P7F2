# ETAPA DE CONSTRUCCIÓN
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
# La compilación genera el JAR ejecutable
RUN mvn clean install -DskipTests

# ETAPA DE EJECUCIÓN
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
# El JAR debe copiarse con su nombre correcto
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
# Comando de inicio
ENTRYPOINT ["java", "-jar", "app.jar"]
