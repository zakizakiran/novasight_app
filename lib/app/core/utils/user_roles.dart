enum UserRoles {
  siswa('Siswa'),
  guru('Guru');

  final String roleName;
  const UserRoles(this.roleName);
}
const allRoles = [UserRoles.siswa,UserRoles.guru];
