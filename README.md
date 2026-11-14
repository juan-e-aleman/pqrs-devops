#  PQRS | Sistema de Peticiones, Quejas, Reclamos y Sugerencias

<p align="center">
  <img src="https://img.shields.io/badge/Proyecto-PQRS-2563EB?style=for-the-badge" alt="Proyecto PQRS">
  <img src="https://img.shields.io/badge/Backend-NestJS-E0234E?style=for-the-badge&logo=nestjs&logoColor=white" alt="NestJS">
  <img src="https://img.shields.io/badge/Frontend-Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white" alt="Angular">
  <img src="https://img.shields.io/badge/Database-PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Containers-Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker">
</p>

<p align="center">
  <strong>Una plataforma para centralizar, gestionar y realizar seguimiento a las solicitudes de la comunidad universitaria.</strong>
</p>

---

##  Sobre el proyecto

**PQRS** es un sistema de información diseñado para gestionar las Peticiones, Quejas, Reclamos y Sugerencias de la comunidad universitaria.

La plataforma busca facilitar el registro de solicitudes, organizar su atención y permitir el seguimiento de cada caso mediante una estructura tecnológica modular.

###  Objetivos principales

-  Centralizar el registro de solicitudes.
-  Facilitar el seguimiento de los casos.
-  Proteger la información mediante mecanismos de autenticación y autorización.
-  Organizar los servicios de la aplicación en una arquitectura modular.
-  Preparar el entorno para futuras prácticas de integración y entrega continua (CI/CD).

---

##  Arquitectura tecnológica

El proyecto está organizado en tres componentes principales, apoyados por servicios de infraestructura y contenedorización.

| Componente | Tecnología | Responsabilidad |
|:---|:---|:---|
|  Frontend | Angular 21 | Interfaz de usuario |
|  Backend | NestJS 11 + TypeORM | API REST y lógica de negocio |
|  Base de datos | PostgreSQL 16 | Persistencia de información |
|  Contenedores | Docker Compose | Orquestación de servicios |
|  Servidor web | Nginx | Entrada web y enrutamiento |

###  Vista general de la arquitectura

```mermaid
flowchart TD
    U[" Usuario"]
    N[" Nginx"]
    F[" Frontend Angular"]
    B[" Backend NestJS"]
    D[(" PostgreSQL")]
    
    U --> N
    N --> F
    N --> B
    B --> D

    subgraph DOCKER[" Entorno Docker Compose"]
        N
        F
        B
        D
    end
```

> **Nota:** Docker Compose permite definir y administrar los servicios del entorno desde un archivo de configuración centralizado.

---

### 🐳 Infraestructura y comunicación de servicios

```mermaid
flowchart TB
    HOST(["💻 Equipo anfitrión"])

    subgraph DOCKER["🐳 Docker Compose"]
        N["🌐 Nginx"]
        F["🖥️ Frontend Angular"]
        B["⚙️ Backend NestJS"]
        DB[("🐘 PostgreSQL 16")]
        VOL[("💾 Volumen persistente")]

        N --> F
        N -->|"Proxy API"| B
        B -->|"Conexión a PostgreSQL"| DB
        DB --- VOL
    end

    HOST -->|"Acceso por puerto publicado"| N

    classDef service fill:#dbeafe,stroke:#2563eb,color:#172554
    classDef database fill:#ede9fe,stroke:#7c3aed,color:#312e81

    class N,F,B service
    class DB,VOL database
```
---

##  Estructura del repositorio

```text
pqrs-devops/
│
├──  pqrs-backend/
│   ├── src/
│   ├── migrations/
│   ├── package.json
│   └── Dockerfile
│
├──  pqrs-frontend/
│   ├── src/
│   ├── package.json
│   └── Dockerfile
│
├──  scripts/
│   └── generate-env.ps1
│
├──  docs/
│
├──  docker-compose.yml
├──  docker-compose.dev.yml
├──  .env.example
├──  .gitignore
└──  README.md
```

---

##  Requisitos previos

Antes de ejecutar el proyecto, asegúrate de contar con las siguientes herramientas:

| Herramienta | Versión / requisito |
|:---|:---|
| Node.js | 20 o superior |
| npm | 9 o superior |
| Docker Desktop | Instalado y en ejecución |
| Git | Instalado |
| PowerShell | Para el script de generación de variables de entorno |

### 🔗 Herramientas oficiales

- [Node.js](https://nodejs.org/)
- [npm](https://www.npmjs.com/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Git](https://git-scm.com/)

---

##  Puesta en marcha

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPOSITORIO>
cd pqrs-devops
```

### 2. Configurar las variables de entorno

El proyecto utiliza variables de entorno para gestionar credenciales, secretos y parámetros de configuración.

Puedes crear o completar el archivo `.env` manualmente desde PowerShell:

```powershell
.\scripts\generate-env.ps1
```

Este script crea `.env` desde `.env.example` si aún no existe. También completa secretos vacíos o marcadores pendientes en un `.env` existente y conserva los valores ya configurados.

En Windows, también puedes ejecutar `setup-pqrs.bat`: este llama al mismo script para preparar `.env` y después continúa con la validación y el levantamiento de Docker Compose.

>  **Importante:** el archivo `.env` contiene información sensible. No debe subirse al repositorio ni compartirse públicamente.

### 3. Construir y levantar los servicios

```bash
docker compose up -d --build
```

### 4. Verificar los contenedores

```bash
docker compose ps
```

Para consultar los registros:

```bash
docker compose logs -f
```

> Los puertos y las direcciones de acceso dependen de la configuración del archivo `.env` y de Docker Compose.

---

##  Comandos útiles

###  Docker Compose

| Comando | Descripción |
|:---|:---|
| `docker compose up -d` | Inicia los servicios en segundo plano |
| `docker compose up -d --build` | Construye e inicia los servicios |
| `docker compose down` | Detiene y elimina los contenedores |
| `docker compose ps` | Consulta el estado de los servicios |
| `docker compose logs -f` | Visualiza los registros en tiempo real |
| `docker compose restart` | Reinicia los servicios |

###  Dependencias

| Comando | Descripción |
|:---|:---|
| `npm install` | Instala las dependencias del proyecto |
| `npm run build` | Construye el backend |
| `npm audit --omit=dev` | Revisa vulnerabilidades en dependencias de producción |

---

##  Seguridad de la aplicación

La configuración del proyecto contempla diferentes medidas para proteger los servicios y la información.

| Medida | Descripción |
|:---|:---|
|  Variables de entorno | Gestión de credenciales y secretos fuera del código fuente |
|  JWT | Autenticación mediante tokens |
|  Control de acceso | Restricción de operaciones según roles y permisos |
|  TLS | Validación de certificados en conexiones SMTP |
|  Docker | Aislamiento y configuración de servicios |
|  Dependencias | Actualización y auditoría de paquetes |


###  Flujo de autenticación y autorización

```mermaid
flowchart TD
    A([" Usuario"]) --> B["Envía credenciales"]
    B --> C["AuthService"]
    C --> D{"¿Credenciales válidas?"}

    D -->|"No"| E[" HTTP 401"]
    D -->|"Sí"| F["Generación del JWT"]

    F --> G["Solicitud a endpoint protegido"]
    G --> H["JwtStrategy<br/>Valida el token"]

    H --> I{"¿Token válido?"}

    I -->|"No"| J[" HTTP 401"]
    I -->|"Sí"| K["RolesGuard<br/>Comprueba permisos"]

    K --> L{"¿Rol autorizado?"}

    L -->|"No"| M[" HTTP 403"]
    L -->|"Sí"| N[" Acceso permitido"]

    N --> O["Ejecución del endpoint"]

    classDef success fill:#dcfce7,stroke:#16a34a,color:#14532d
    classDef error fill:#fee2e2,stroke:#dc2626,color:#7f1d1d
    classDef process fill:#dbeafe,stroke:#2563eb,color:#172554

    class N,O success
    class E,J,M error
    class C,F,H,K process
```


### Buenas prácticas

- No publicar archivos `.env`.
- No incluir contraseñas ni secretos en el código fuente.
- Utilizar contraseñas y secretos robustos.
- Mantener actualizadas las dependencias.
- Revisar los permisos de acceso a los endpoints.
- Validar las configuraciones antes de desplegar.

---

##  Base de datos y migraciones

El backend utiliza **TypeORM** para gestionar la estructura y evolución de la base de datos PostgreSQL.

Las migraciones permiten registrar y aplicar cambios de estructura de manera controlada.

### Comandos principales

```bash
# Consultar migraciones
npm run typeorm -- migration:show -d src/db/data-source.ts

# Generar una migración
npm run migration:generate -- src/db/migrations/NombreDeLaMigracion

# Ejecutar migraciones
npm run migrate

# Revertir la última migración
npm run migrate:revert

# Cargar datos iniciales
npm run seed
```

> Ejecuta los comandos desde el directorio que corresponda a los scripts definidos en el `package.json` del backend o del proyecto raíz.

---

##  API REST

El backend está desarrollado con NestJS y expone servicios REST para la gestión de las solicitudes.

La documentación interactiva de Swagger permite consultar los endpoints, sus parámetros y las respuestas de la API.

**Documentación local:**

```text
http://localhost:3000/api
```

*La dirección depende del puerto configurado para el backend.*

---

##  Documentación adicional

| Documento | Descripción |
|:---|:---|
| `CASOS_DE_USO.md` | Casos de uso del sistema |
| `ESTADOS_FLUJO.md` | Flujo de estados de una PQRS |
| `PRIORIDAD.md` | Criterios de priorización |
| `SEGURIDAD.md` | Consideraciones de seguridad |
| `USUARIOS_SEED.md` | Información sobre usuarios de prueba |
| `pqrs-backend/FILE_UPLOAD_DOCUMENTATION.md` | Documentación de carga de archivos |

---

##  Solución de problemas

<details>
<summary><strong> Error de conexión con PostgreSQL</strong></summary>

Verifica que Docker esté en ejecución y que el contenedor de PostgreSQL esté activo:

```bash
docker compose ps
docker compose logs postgres
```

</details>

<details>
<summary><strong> Puerto ocupado</strong></summary>

Comprueba qué servicio está utilizando el puerto y revisa la configuración de puertos en Docker Compose y las variables de entorno.

</details>

<details>
<summary><strong> Error al ejecutar migraciones</strong></summary>

Verifica la conexión a la base de datos, las credenciales y que el servicio PostgreSQL esté disponible.

```bash
docker compose logs postgres
```

</details>

<details>
<summary><strong> Problemas con las dependencias</strong></summary>

Verifica que estés utilizando una versión compatible de Node.js y ejecuta la instalación de dependencias en el directorio correspondiente.

</details>

---

##  Desarrollo y colaboración

Este proyecto se desarrolla bajo un esquema de trabajo colaborativo utilizando Git y GitHub.

Se emplean ramas para organizar las funcionalidades, correcciones y tareas de desarrollo.

### Flujo de trabajo

```mermaid
flowchart LR
    M["main"]
    D["develop"]
    F["feature/*"]
    P["Pull Request"]
    
    M --> D
    D --> F
    F --> P
    P --> D
```

Las contribuciones se integran mediante Pull Requests y revisión de cambios, siguiendo las reglas de colaboración definidas por el equipo.

---

<p align="center">
  <strong> PQRS — Tecnología para una gestión universitaria más organizada.</strong>
  <br>
  <sub>Proyecto académico · Desarrollo de Software</sub>
</p>
