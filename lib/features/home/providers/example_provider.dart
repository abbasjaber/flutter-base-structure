import 'package:app/features/home/repositories/example_repository.dart';
import 'package:app/core/network/api_response.dart';
import 'package:app/core/network/response_model.dart';
import 'package:flutter/foundation.dart';

class ExampleProvider extends ChangeNotifier {
  final ExampleRepo exampleRepo;
  
  ResponseModel? responseModel;
  ApiResponse? apiResponse;
  bool isLoading = false;

  ExampleProvider({required this.exampleRepo});

  Future<ResponseModel?> getItems() async {
    isLoading = true;
    notifyListeners();

    apiResponse = await exampleRepo.get();
    
    if (apiResponse != null && 
        apiResponse!.response != null && 
        (apiResponse!.response!.statusCode == 200 || apiResponse!.response!.statusCode == 304)) {
      responseModel = ResponseModel(true, 'Success');
    } else {
      String errorMessage = 'An error occurred';
      if (apiResponse?.response?.data != null && apiResponse!.response!.data is Map) {
        errorMessage = apiResponse!.response!.data['message'] ?? errorMessage;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    
    isLoading = false;
    notifyListeners();
    return responseModel;
  }
}
