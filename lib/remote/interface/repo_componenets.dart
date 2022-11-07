import 'package:app/remote/response/api_response.dart';

abstract class CompoAbstract {
  Future<ApiResponse> getlists(dynamic model);
  Future<ApiResponse> getObjects(dynamic model);
}
