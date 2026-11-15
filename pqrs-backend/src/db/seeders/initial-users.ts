import { UserRole } from '../../users/entities/user.entity';

export interface InitialUserSeed {
  id: string;
  nombre: string;
  email: string;
  password: string;
  rol: UserRole;
}

// IDs estables para que la migración pueda identificar exactamente estas
// cuentas sin borrar usuarios preexistentes durante un rollback.
export const INITIAL_USERS: InitialUserSeed[] = [
  {
    id: '00000000-0000-4000-8000-000000000001',
    nombre: 'Administrador Maestro',
    email: 'admin_master@gmail.com',
    password: 'Adm1n#2026',
    rol: UserRole.ADMIN,
  },
  {
    id: '00000000-0000-4000-8000-000000000002',
    nombre: 'Supervisor PQRS',
    email: 'supervisor_pqrs@gmail.com',
    password: 'Sup3rPqrs!',
    rol: UserRole.SUPERVISOR,
  },
  {
    id: '00000000-0000-4000-8000-000000000003',
    nombre: 'Cliente Portal',
    email: 'cliente_portal@gmail.com',
    password: 'Cl13nte$Web',
    rol: UserRole.USUARIO,
  },
];
