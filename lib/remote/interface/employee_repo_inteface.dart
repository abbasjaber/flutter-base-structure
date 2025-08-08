import 'package:app/remote/response/api_response.dart';

abstract class EmployeeRepoInterface {
  Future<ApiResponse> getClients();
  Future<ApiResponse> getHistory();
}
