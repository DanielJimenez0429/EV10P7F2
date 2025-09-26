# ETAPA 1: CONSTRUCCIÓN (BUILD)
# Usamos una imagen con Maven y JDK 21 (basado en su pom.xml)
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

# Copia los archivos de configuración y código
COPY pom.xml .
COPY src ./src

# Compila el proyecto y genera el JAR. 
# El fix en pom.xml asegura que el manifiesto sea correcto.
RUN mvn clean install -DskipTests

# ETAPA 2: EJECUCIÓN (RUNTIME)
# Usamos una imagen ligera de JRE 21 para la ejecución
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# 🔴 FIX CRÍTICO: Copiamos el archivo JAR con su nombre exacto.
# Lo renombramos a "app.jar" para simplificar el comando de inicio.
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

# Render usará la variable de entorno $PORT, pero exponemos 8080 por convención.
EXPOSE 8080

# Comando de inicio: Ejecuta el JAR renombrado.
ENTRYPOINT ["java", "-jar", "app.jar"]
