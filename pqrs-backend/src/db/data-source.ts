import { DataSource } from 'typeorm';
import * as dotenv from 'dotenv';
import * as path from 'path';

// Cargar las variables del .env ubicado en la raíz del proyecto.
// En Docker Compose, las variables se reciben directamente del entorno.
dotenv.config({ path: path.resolve(process.cwd(), '../.env') });

// Exigir las variables necesarias para la conexión.
function getRequiredEnv(name: string): string {
  const value = process.env[name];

  if (!value) {
    throw new Error(`Falta la variable de entorno obligatoria: ${name}`);
  }

  return value;
}

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: getRequiredEnv('DB_HOST'),
  port: parseInt(getRequiredEnv('DB_PORT'), 10),
  username: getRequiredEnv('DB_USER'),
  password: getRequiredEnv('DB_PASSWORD'),
  database: getRequiredEnv('DB_NAME'),
  entities: [path.join(__dirname, '../**/*.entity.{js,ts}')],
  migrations: [path.join(__dirname, './migrations/*.{js,ts}')],
  synchronize: false,
  logging: process.env.NODE_ENV !== 'production',
});
