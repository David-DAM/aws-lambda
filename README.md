# Proyecto AWS Lambda con Spring Boot 3

Este proyecto implementa un servicio CRUD de productos utilizando AWS Lambda y Spring Boot 3. Las imágenes asociadas a
los productos se almacenan en un bucket de S3. Además, se utiliza Terraform para gestionar la infraestructura necesaria
en AWS, incluyendo la base de datos PostgreSQL, S3, API Gateway y los permisos necesarios para la ejecución de la
Lambda.

## Tabla de Contenidos

- [Requisitos Previos](#requisitos-previos)
- [Arquitectura](#arquitectura)
- [Instalación](#instalación)
- [Ejecución](#ejecución)
- [Flujo de la Aplicación](#flujo-de-la-aplicación)
- [Infraestructura con Terraform](#infraestructura-con-terraform)
- [Dependencias](#dependencias)
- [Contribuciones](#contribuciones)

---

## Requisitos Previos

- **Java**: Versión 17 o superior.
- **Maven**: Para construir el proyecto.
- **Terraform**: Instalado y configurado.
- **AWS CLI**: Configurado con credenciales y permisos adecuados.

## Arquitectura

El proyecto sigue una arquitectura basada en AWS Lambda con los siguientes componentes principales:

- **AWS Lambda**: Funciones para manejar las operaciones CRUD.
- **Amazon API Gateway**: Punto de entrada para las solicitudes HTTP.
- **Amazon S3**: Almacenamiento de imágenes de productos.
- **Amazon RDS (PostgreSQL)**: Base de datos para almacenar los datos de los productos.
- **IAM Roles y Policies**: Gestión de permisos para los recursos de AWS.

## Instalación

1. Clona el repositorio:
   ```bash
   git clone https://github.com/DAVID-DAM/aws-lambda.git
   cd aws-lambda
   ```

2. Construye el proyecto usando Maven:
   ```bash
   mvn clean package
   ```

3. Configura los recursos de AWS usando Terraform:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

   Esto creará los recursos necesarios en tu cuenta de AWS.

## Ejecución

1. Genera el artefacto `.jar` o `.zip` necesario para AWS Lambda:
   ```bash
   mvn package
   ```

2. Despliega la función Lambda utilizando Terraform o manualmente a través de la consola de AWS.

3. Una vez desplegado, utiliza la URL proporcionada por API Gateway para interactuar con el servicio CRUD.

## Flujo de la Aplicación

1. **Operaciones CRUD**:
    - Crear, leer, actualizar y eliminar productos.
    - Los datos de los productos se almacenan en PostgreSQL.

2. **Gestión de Imágenes**:
    - Al crear o actualizar un producto, las imágenes asociadas se cargan a un bucket de S3.
    - Las URLs de las imágenes se almacenan en la base de datos.

3. **Respuesta**:
    - Los endpoints de API Gateway devuelven respuestas JSON con el estado de las operaciones y los datos de los
      productos.

## Infraestructura con Terraform

### Recursos Creados

- **Lambda Function**: Implementa la lógica del CRUD.
- **API Gateway**: Exposición de los endpoints HTTP.
- **RDS (PostgreSQL)**: Base de datos para almacenamiento.
- **S3 Bucket**: Almacenamiento de imágenes.
- **IAM Roles y Policies**: Gestión de permisos para acceder a los recursos.

### Configuración Básica

1. Configura las variables db_username y db_password creando el archivo `terraform/secret.tfvars`.
2. Aplica los cambios con:
   ```bash
   terraform apply
   ```

Esto creará y configurará automáticamente todos los recursos.

## Dependencias

Las principales dependencias utilizadas en el proyecto son:

- **Spring Boot**: Para la estructura y lógica de la aplicación.
- **Lombok**: Reducción de código repetitivo.
- **Spring Data JPA**: Para la interacción con PostgreSQL.
- **AWS SDK**: Para interactuar con S3 y otros servicios de AWS.

## Contribuciones

¡Contribuciones son bienvenidas! Si tienes ideas, mejoras o encuentras algún problema, abre un issue o envía un pull
request.