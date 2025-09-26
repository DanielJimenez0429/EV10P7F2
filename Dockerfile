# ETAPA 1: CONSTRUCCIÓN (BUILD)
FROM maven:3.9.6-eclipse-temurin-21 AS build

# Copiamos todo el repositorio a /app
COPY . /app

# Configuramos el directorio de trabajo para que sea donde están los artefactos de Maven
WORKDIR /app/demo 

# 🔴 FIX CRÍTICO: Ejecutamos el clean install desde el directorio 'demo' 
# (donde está el src y se esperaría el pom.xml, pero como el pom.xml está en la raíz, usaremos el comando mvn de otra manera)

# El comando mvn DEBE ejecutarse donde está el pom.xml, que es la raíz.
# Pero el código fuente está en una subcarpeta 'demo/src'

# Regresamos al método anterior, pero con las rutas correctas:

FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# 1. Copia el pom.xml desde la raíz (donde está)
COPY pom.xml .

# 2. Copia la carpeta 'demo' que contiene el 'src'
COPY demo/ ./demo

# 3. Compila el proyecto, apuntando al pom.xml y al código fuente.
# Necesitamos decirle a Maven dónde encontrar el src. La forma más fácil es 
# copiar y trabajar en la estructura estándar:

# COPIAMOS TODO A LA RAIZ DEL CONTENEDOR Y NOS FIJAMOS EN EL POM.XML

FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copia el pom.xml de la raíz
COPY pom.xml .

# 🔴 FIX CRÍTICO: Copiamos el contenido de 'demo/src' a la raíz del WORKDIR (/app/src)
# Si su código fuente principal es 'demo/src', el Dockerfile debe reflejarlo:
COPY demo/src ./src 

# Esto no funcionará si la carpeta 'target' ya existe, y no queremos copiar target.

# ¡La solución más simple es copiar todo y luego compilar!
