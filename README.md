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
---

## Diagrama de Casos de Uso

Representación de los actores del sistema (`Ciudadano`, `Funcionario`, `Administrador` y `Sistema`) y su interacción con los 18 casos de uso agrupados por módulo.

```mermaid
flowchart LR
    %% Actores
    C(["Ciudadano<br/>(rol: usuario)"])
    F(["Funcionario / Supervisor<br/>(rol: supervisor)"])
    A(["Administrador<br/>(rol: admin)"])
    S(["Sistema<br/>(Automatizado / Cron)"])

    %% Herencia de roles
    A -.->|"Hereda permisos"| F
    F -.->|"Hereda permisos"| C

    subgraph SISTEMA["Sistema de Gestión PQRS"]
        direction TB

        subgraph MOD_AUTH["Módulo Autenticación"]
            CU01(["CU-01: Registrarse"])
            CU02(["CU-02: Iniciar sesión"])
            CU03(["CU-03: Cerrar sesión"])
            CU17(["CU-17: Validar token JWT"])
        end

        subgraph MOD_PQRS["Módulo Gestión PQRS"]
            TRACK(["Consulta pública por radicado"])
            CU04(["CU-04: Crear PQRS"])
            CU05(["CU-05: Consultar mis PQRS"])
            CU06(["CU-06: Ver detalle PQRS"])
            CU08(["CU-08: Responder PQRS (Ciudadano)"])
            CU09(["CU-09: Eliminar PQRS"])
            CU10(["CU-10: Ver todas las PQRS"])
            CU11(["CU-11: Responder PQRS (Admin/Func)"])
            CU12(["CU-12: Cambiar estado PQRS"])
        end

        subgraph MOD_FILES["Módulo Archivos"]
            CU07(["CU-07: Descargar adjunto"])
            CU15(["CU-15: Subir archivos adicionales"])
            CU16(["CU-16: Eliminar adjunto"])
            CU18(["CU-18: Limpieza nocturna (@Cron)"])
        end

        subgraph MOD_ADMIN["Panel Administrativo"]
            CU13(["CU-13: Ver estadísticas"])
            CU14(["CU-14: Gestionar usuarios"])
        end
    end

    %% Relaciones Ciudadano
    C --> CU01 & CU02 & CU03
    C --> TRACK & CU04 & CU05 & CU06 & CU08 & CU09
    C --> CU07 & CU15 & CU16

    %% Relaciones Funcionario / Supervisor
    F --> CU10 & CU11 & CU12 & CU13

    %% Relaciones Administrador
    A --> CU14

    %% Relaciones Sistema
    S --> CU17 & CU18

    %% Include y Extend
    CU04 -.->|"&lt;&lt;include&gt;&gt;"| CU15
    CU17 -.->|"&lt;&lt;extend&gt;&gt;"| CU04 & CU05 & CU06 & CU15
    CU12 -.->|"&lt;&lt;extend&gt;&gt;"| CU11

    classDef actor fill:#dbeafe,stroke:#2563eb,color:#172554,stroke-width:2px
    classDef auto fill:#fef3c7,stroke:#d97706,color:#78350f,stroke-width:2px
    classDef usecase fill:#f8fafc,stroke:#475569,color:#0f172a

    class C,F,A actor
    class S auto
    class CU01,CU02,CU03,CU17,TRACK,CU04,CU05,CU06,CU08,CU09,CU10,CU11,CU12,CU07,CU15,CU16,CU18,CU13,CU14 usecase
```

---

## Diagrama de Despliegue (Docker & Infraestructura)

Distribución física y lógica de los nodos, contenedores Docker, volúmenes persistentes y servicios externos en producción.

```mermaid
flowchart TB
    subgraph CLIENTE["Dispositivo Cliente (PC / Móvil)"]
        subgraph BROWSER["Navegador Web"]
            SPA["Angular 21 SPA<br/>(Archivos estáticos)"]
            LS[("LocalStorage<br/>accessToken / refreshToken")]
        end
    end

    subgraph HOST["Servidor Host / Docker Engine"]
        ENV["Archivo .env<br/>(JWT_SECRET, DB_PASSWORD, SMTP)"]

        subgraph NET["Red Interna Docker (pqrs-network)"]
            subgraph C_FRONT["Contenedor: pqrs-frontend"]
                NGINX["Nginx Web Server<br/>Puerto 80 / 443"]
            end

            subgraph C_BACK["Contenedor: pqrs-backend"]
                NEST["API REST NestJS 11<br/>Node.js 20 · Puerto 3000<br/>(JWT/RolesGuard, Multer, @Cron)"]
            end

            subgraph C_DB["Contenedor: pqrs-db"]
                PG[("PostgreSQL 16<br/>Puerto 5432")]
            end
        end

        VOL_UP[("Volumen: uploads_data<br/>/app/uploads/pqrs")]
        VOL_DB[("Volumen: postgres_data<br/>/var/lib/postgresql/data")]
    end

    subgraph EXT["Servicios Externos"]
        SMTP["Servidor SMTP<br/>(Notificaciones Email · TLS 587)"]
    end

    %% Flujo de red y volúmenes
    BROWSER -->|"HTTPS (80/443)"| NGINX
    NGINX -->|"Sirve SPA"| SPA
    NGINX -->|"Reverse Proxy /api"| NEST
    NEST -->|"TCP / TypeORM (5432)"| PG
    NEST -->|"SMTP / TLS (587)"| SMTP

    NEST ---|"Montaje R/W"| VOL_UP
    PG ---|"Persistencia BD"| VOL_DB
    ENV -.->|"Inyección env"| C_BACK
    ENV -.->|"Inyección env"| C_DB

    classDef service fill:#dbeafe,stroke:#2563eb,color:#172554
    classDef database fill:#ede9fe,stroke:#7c3aed,color:#312e81
    classDef security fill:#dcfce7,stroke:#16a34a,color:#14532d
    classDef external fill:#fef3c7,stroke:#d97706,color:#78350f

    class NGINX,NEST,SPA service
    class PG,VOL_UP,VOL_DB,LS database
    class ENV security
    class SMTP external
```

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

En Windows PowerShell, desde la raíz del proyecto:

```powershell
.\scripts\generate-env.ps1
```

Este script genera el archivo `.env` a partir de `.env.example`, incluyendo secretos aleatorios para la configuración inicial.

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
