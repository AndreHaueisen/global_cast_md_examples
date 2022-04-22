import 'package:global_cast_md_examples/data/data_user.dart';

import 'api_service.dart';

class UserService {
  final ApiService _apiService;

  const UserService(this._apiService);

  Future<ResponseResult<DataUser>> fetchUser() async {
    const path = '';

    final response = await _apiService.get(path: path);
    if (response.isSuccess) {
      return ResponseResult.success(DataUser.fromJson(response.data));
    } else {
      return ResponseResult.error(response.errorMessage);
    }
  }
}