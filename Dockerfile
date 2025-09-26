# =========================================================================
# ETAPA 1: CONSTRUCCIÓN (BUILD STAGE)
# Usa la imagen base de Maven con JDK 21
# =========================================================================
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el pom.xml de la raíz
COPY pom.xml .

# FIX CRÍTICO DE RUTA: Copia la carpeta 'src' anidada (demo/src) a la ubicación estándar de Maven (/app/src)
COPY demo/src ./src

# Compila el proyecto: genera el JAR ejecutable en /app/target/
RUN mvn clean install -DskipTests


# =========================================================================
# ETAPA 2: EJECUCIÓN (RUNTIME STAGE)
# Usa una imagen ligera de JRE 21 (solo para ejecutar, no para compilar)
# =========================================================================
FROM eclipse-temurin:21-jre-alpine

# Establece el directorio de trabajo para la ejecución
WORKDIR /app

# Copia el JAR compilado de la etapa 'build' y lo renombra a 'app.jar'
# El nombre del JAR se basa en el pom.xml: demo-0.0.1-SNAPSHOT.jar
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

# Comando de inicio: Ejecuta el JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
