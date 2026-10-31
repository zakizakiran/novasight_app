enum UserRoles {
  siswa('Siswa'),
  guru('Guru');

  final String roleName;
  const UserRoles(this.roleName);
}
const allRoles = [UserRoles.siswa,UserRoles.guru];

class UserRoleHelper {
  static String mapRoleToBackend(UserRoles role) {
    switch (role) {
      case UserRoles.siswa:
        return 'student';
      case UserRoles.guru:
        return 'teacher';
    }
  }

  static UserRoles mapBackendToRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return UserRoles.siswa;
      case 'teacher':
      default:
        return UserRoles.guru;
    }
  }
}
