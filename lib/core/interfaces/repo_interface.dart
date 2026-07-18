import 'package:app/core/network/api_response.dart';

abstract class RepoAbstract {
  Future<ApiResponse> get();
}
