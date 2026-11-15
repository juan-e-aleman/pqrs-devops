import { EntityManager } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from '../../users/entities/user.entity';
import { INITIAL_USERS } from './initial-users';

export async function seedUsers(manager: EntityManager): Promise<void> {
  const userRepository = manager.getRepository(User);

  for (const userData of INITIAL_USERS) {
    // Check if user already exists
    const existingUser = await userRepository.findOne({
      where: { email: userData.email },
    });

    if (existingUser) {
      console.log(`✓ Usuario ${userData.email} ya existe. Saltando...`);
      continue;
    }

    // Check if user exists with old email format (without @gmail.com)
    const oldEmail = userData.email.replace('@gmail.com', '');
    const userWithOldEmail = await userRepository.findOne({
      where: { email: oldEmail },
    });

    if (userWithOldEmail) {
      // Update email to new format
      userWithOldEmail.email = userData.email;
      await userRepository.save(userWithOldEmail);
      console.log(`✓ Usuario ${oldEmail} actualizado a ${userData.email}`);
      continue;
    }

    // Hash password
    const passwordHash = await bcrypt.hash(userData.password, 12);

    // Create user
    const user = userRepository.create({
      id: userData.id,
      nombre: userData.nombre,
      email: userData.email,
      passwordHash,
      rol: userData.rol,
      isActive: true,
    });

    await userRepository.save(user);
    console.log(`✓ Usuario ${userData.email} creado exitosamente con rol ${userData.rol}`);
  }

  console.log('✓ Seeding de usuarios completado.');
}
