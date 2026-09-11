class LoginRequestModel {
  final String email;
  final String password;
  final String role; // "student" or "teacher"

  const LoginRequestModel({
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
    );
  }
}

class RegisterStudentRequestModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  const RegisterStudentRequestModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.role = 'student',
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
      'role': role,
    };
  }

  factory RegisterStudentRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterStudentRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirm_password'] as String,
      role: json['role'] as String? ?? 'student',
    );
  }
}

class RegisterTeacherRequestModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  const RegisterTeacherRequestModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.role = 'teacher',
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
      'role': role,
    };
  }

  factory RegisterTeacherRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterTeacherRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirm_password'] as String,
      role: json['role'] as String? ?? 'teacher',
    );
  }
}
