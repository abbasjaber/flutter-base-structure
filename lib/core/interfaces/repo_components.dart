import 'package:app/core/network/api_response.dart';

abstract class CompoAbstract {
  Future<ApiResponse> getlists(dynamic model);
  Future<ApiResponse> getObjects(dynamic model);
}
