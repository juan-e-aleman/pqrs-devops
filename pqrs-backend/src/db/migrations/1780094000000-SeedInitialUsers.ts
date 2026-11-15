import { MigrationInterface, QueryRunner } from 'typeorm';
import { seedUsers } from '../seeders/user.seeder';
import { INITIAL_USERS } from '../seeders/initial-users';

export class SeedInitialUsers1780094000000 implements MigrationInterface {
  name = 'SeedInitialUsers1780094000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Usa el mismo seeder manual y la transacción de esta migración.
    await seedUsers(queryRunner.manager);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Solo se eliminan filas creadas por esta migración, nunca cuentas previas
    // que coincidan por correo. No se borran cuentas con actividad asociada:
    // PQRS, asignaciones, respuestas o historial.
    const ids = INITIAL_USERS.map((user) => user.id);
    await queryRunner.query(
      `DELETE FROM "users"
       WHERE "id" = ANY($1::uuid[])
         AND NOT EXISTS (SELECT 1 FROM "pqrs" WHERE "pqrs"."userId" = "users"."id")
         AND NOT EXISTS (SELECT 1 FROM "pqrs" WHERE "pqrs"."supervisorAsignadoId" = "users"."id")
         AND NOT EXISTS (SELECT 1 FROM "pqrs_respuestas" WHERE "pqrs_respuestas"."autorId" = "users"."id")
         AND NOT EXISTS (SELECT 1 FROM "pqrs_historial" WHERE "pqrs_historial"."actorId" = "users"."id")`,
      [ids],
    );
  }
}
