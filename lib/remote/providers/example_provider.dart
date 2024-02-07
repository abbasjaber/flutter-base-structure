import 'package:app/remote/repositories/example_repository.dart';
import 'package:app/remote/response/api_response.dart';
import 'package:app/remote/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ExamoleProvider extends ChangeNotifier {
  ResponseModel? responseModel;
  ApiResponse? apiResponse;
  ExamoleRepo? examoleRepo;
  ExamoleProvider({this.examoleRepo});

  Future<ResponseModel?> getItems() async {
    apiResponse = await examoleRepo!.get();
    if (apiResponse!.response != null &&
            apiResponse!.response!.statusCode == 200 ||
        apiResponse!.response!.statusCode == 304) {
      responseModel = ResponseModel(true, 'Success');
    } else {
      responseModel =
          ResponseModel(false, apiResponse!.response!.data['message']);
    }
    notifyListeners();
    return responseModel;
  }
}
