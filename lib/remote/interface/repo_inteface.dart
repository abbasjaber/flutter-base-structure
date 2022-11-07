import 'package:app/remote/response/api_response.dart';

abstract class RepoAbstract {
  Future<ApiResponse> get();
}
