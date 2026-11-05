# 📋 Sistema PQRS

Sistema de gestión de **Peticiones, Quejas, Reclamos y Sugerencias** construido con:

| Capa | Tecnología |
|------|-----------|
| Frontend | Angular 21 |
| Backend | NestJS 11 + TypeORM |
| Base de datos | PostgreSQL 16 (Docker) |

---

## 🗂️ Estructura del repositorio

```
brandon/
├── pqrs-backend/      # API REST (NestJS)
├── pqrs-frontend/     # Aplicación web (Angular)
├── docker-compose.yml # PostgreSQL, backend, frontend y Nginx
├── nginx/             # Reverse proxy
├── package.json       # Scripts raíz del monorepo
└── README.md
```

---

## ⚙️ Requisitos previos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y abierto.
- No necesitas instalar Node.js para ejecutar la aplicación con Docker.

---

## 🚀 Inicio local con Docker

Abre una terminal en la carpeta raíz del proyecto (donde está `docker-compose.yml`) y ejecuta:

```bash
Copy-Item .env.example .env
docker compose up --build
```

En PowerShell, el primer comando crea tu archivo local `.env` a partir del ejemplo. Puedes editarlo para cambiar credenciales y puertos antes de iniciar.

La primera vez Docker descarga las imágenes e instala las dependencias dentro de los contenedores; puede tardar unos minutos. Al terminar, abre:

- Aplicación web: <http://localhost:8080>
- API y documentación: <http://localhost:8080/api/docs>

Nginx es el único servicio publicado en tu máquina. Envía `/api` y `/uploads` al backend y el resto de rutas al frontend. El backend espera a que PostgreSQL esté listo y aplica las migraciones al iniciar. PostgreSQL solo es accesible por la red interna de Docker. Puedes detener todo con `Ctrl+C`; para detener y retirar los contenedores ejecuta `docker compose down`. Los datos de PostgreSQL se conservan en un volumen.

Para iniciar en segundo plano: `docker compose up --build -d`. Para ver qué está pasando: `docker compose logs -f`. Para reconstruir tras cambios en Dockerfiles o dependencias: `docker compose up --build`.

> El compose usa credenciales y secretos de desarrollo local. No los uses para publicar la aplicación en internet.

---

## 📦 Scripts disponibles

### Instalación de dependencias

| Comando | Descripción |
|---------|-------------|
| `npm run install:all` | Instala dependencias de backend **y** frontend |
| `npm run install:backend` | Solo backend |
| `npm run install:frontend` | Solo frontend |

### 🐳 Base de datos y aplicación (Docker)

| Comando | Descripción |
|---------|-------------|
| `docker compose up --build` | Construye e inicia base de datos, backend, frontend y Nginx |
| `docker compose down` | Detiene y retira los contenedores (conserva la base de datos) |
| `docker compose logs -f` | Muestra los logs en tiempo real |
| `docker compose down -v` | Borra también los datos de la base de datos |

> **Credenciales locales de la base de datos** (ver `.env`):
> - Host: solo dentro de Docker (`postgres`) · Puerto interno: `5432`
> - Usuario: `pqrs_user` · Contraseña: `pqrs_pass` · DB: `pqrs`

### 🗄️ Migraciones

| Comando | Descripción |
|---------|-------------|
| `docker compose exec backend npm run migration:run` | Ejecuta migraciones pendientes manualmente |
| `docker compose exec backend npm run migration:revert` | Revierte la última migración aplicada |
| `docker compose exec backend npm run seed` | Carga datos iniciales (usuarios, roles, etc.) |

> Las migraciones pendientes se ejecutan automáticamente al iniciar el backend con Compose.

### ▶️ Desarrollo

| Comando | Descripción |
|---------|-------------|
| `npm start` | Levanta Docker + backend + frontend en paralelo |
| `npm run dev` | Backend y frontend en paralelo (sin tocar Docker) |
| `npm run dev:backend` | Solo backend (modo watch) |
| `npm run dev:frontend` | Solo frontend |

### 🏁 Setup completo

```bash
npm run setup   # db:up + install:all + migrate
npm start       # db:up + dev (backend + frontend)
```

---

## 🔧 Variables de entorno

Docker Compose lee las variables del archivo `.env` ubicado en la raíz del repositorio. Créalo con `Copy-Item .env.example .env` en PowerShell y edítalo según necesites. No subas `.env` a Git: está excluido por `.gitignore`. `NGINX_PORT` define el puerto de entrada en tu máquina (por defecto 8080). El backend se conecta a la base de datos usando `DB_HOST=postgres` y `DB_PORT=5432`; ni la base de datos ni los servicios de aplicación publican puertos al host.

---

## 🗄️ Flujo de migraciones (detallado)

Las migraciones están gestionadas con **TypeORM CLI** desde el backend.

### Ver migraciones disponibles

```bash
cd pqrs-backend
npm run typeorm -- migration:show -d src/db/data-source.ts
```

### Generar una nueva migración

```bash
cd pqrs-backend
npm run migration:generate -- src/db/migrations/NombreDeLaMigracion
```

### Aplicar migraciones (desde raíz)

```bash
npm run migrate
```

### Revertir la última migración (desde raíz)

```bash
npm run migrate:revert
```

### Cargar datos semilla

```bash
npm run seed
```

> Los seeders crean los usuarios iniciales del sistema. Revisa [`USUARIOS_SEED.md`](./USUARIOS_SEED.md) para ver las credenciales.

---

## 📡 Endpoints principales

Una vez que el backend está corriendo, la documentación Swagger está disponible en:

```
http://localhost:8080/api/docs
```

---

## 🐛 Solución de problemas frecuentes

### `ECONNREFUSED` al conectar con la base de datos
```bash
# Verifica que Docker esté corriendo
npm run db:up
npm run db:logs   # Espera hasta ver "database system is ready"
```

### Puerto 8080 ocupado
Cambia el puerto de entrada de Nginx en el archivo `.env`:
```env
NGINX_PORT=8081
```

### Error de migración `relation already exists`
```bash
npm run migrate:revert   # revierte la última
npm run migrate          # vuelve a aplicar
```

### `concurrently: command not found`
```bash
npm install   # instala devDependencies del package.json raíz
```

---

## 📚 Documentación adicional

| Archivo | Contenido |
|---------|-----------|
| [`CASOS_DE_USO.md`](./CASOS_DE_USO.md) | Casos de uso del sistema |
| [`ESTADOS_FLUJO.md`](./ESTADOS_FLUJO.md) | Flujo de estados de una PQRS |
| [`PRIORIDAD.md`](./PRIORIDAD.md) | Criterios de priorización |
| [`SEGURIDAD.md`](./SEGURIDAD.md) | Consideraciones de seguridad |
| [`USUARIOS_SEED.md`](./USUARIOS_SEED.md) | Credenciales de usuarios semilla |
| [`pqrs-backend/FILE_UPLOAD_DOCUMENTATION.md`](./pqrs-backend/FILE_UPLOAD_DOCUMENTATION.md) | Carga de archivos |
