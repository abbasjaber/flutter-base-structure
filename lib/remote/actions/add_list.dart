import 'package:app/remote/response/api_response.dart';
import 'package:app/remote/response/response_model.dart';

abstract class AddListAbstract {
  ApiResponse? apiResponse;
  ResponseModel? responseModel;
  dynamic model;
  List<dynamic>? _modelList = [];
  List<dynamic>? get modelList => _modelList;

  ResponseModel? addList() {
    if (apiResponse!.response != null &&
        apiResponse!.response?.statusCode == 200) {
      apiResponse!.response?.data['data'].forEach((x) {
        _modelList!.add(model.fromJson(x));
      });
      responseModel =
          ResponseModel(true, apiResponse!.response?.data['message']);
    } else if (apiResponse!.response != null &&
        apiResponse!.response?.statusCode == 500) {
      responseModel =
          ResponseModel(false, apiResponse!.response?.data['message']);
    }
    return responseModel;
  }
}
