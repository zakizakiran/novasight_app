import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  final InternetConnectionChecker _checker =
  InternetConnectionChecker.createInstance();

  Future<bool> get hasInternetAccess async {
    return await _checker.hasConnection;
  }
}