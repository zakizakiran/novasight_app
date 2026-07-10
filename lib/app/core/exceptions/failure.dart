import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception{
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No internet connection"]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = "Server error"]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = "Unauthorized"]);
}

class AppFailure extends Failure {
  const AppFailure([super.message = "App Error"]);
}
