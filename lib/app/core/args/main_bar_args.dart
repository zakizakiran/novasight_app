
import 'package:novasight_app/app/core/utils/user_roles.dart';

class MainBarArgs {
  final int index;
  final UserRoles role;

  const MainBarArgs({
    this.index = 0,
    required this.role,
  });
}