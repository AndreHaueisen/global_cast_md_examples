import 'package:global_cast_md_examples/services/user_service.dart';

import 'services/api_dio.dart';
import 'services/api_service.dart';

class AppConfig {

  final ApiService apiService;

  late final UserService userService;

  AppConfig() : apiService = ApiService(ApiDio());

  void initialize() {
    userService = UserService(apiService);
  }

}