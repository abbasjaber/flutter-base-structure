import 'package:app/remote/response/api_response.dart';
import 'package:app/remote/response/response_model.dart';

abstract class AddObjectAbstract {
  ApiResponse? apiResponse;
  ResponseModel? responseModel;
  dynamic _model = {};
  dynamic get model => _model;

  ResponseModel? addList() {
    if (apiResponse!.response != null &&
        apiResponse!.response?.statusCode == 200) {
      _model = model.fromJson(apiResponse!.response?.data['data']);
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
