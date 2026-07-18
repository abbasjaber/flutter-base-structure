import 'package:app/features/auth/models/user_model.dart';
import 'package:app/features/auth/repositories/auth_repository.dart';
import 'package:app/core/network/api_response.dart';
import 'package:app/core/network/response_model.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _loginErrorMessage;
  String? get loginErrorMessage => _loginErrorMessage;

  String? _deletedMessage;
  String? get deletedMessage => _deletedMessage;

  ResponseModel? responseModel;
  ApiResponse? apiResponse;

  Future<ResponseModel?> login(UserModel c) async {
    _isLoading = true;
    _loginErrorMessage = null;
    notifyListeners();

    apiResponse = await authRepo.login(c);
    
    if (apiResponse != null && apiResponse!.response != null && apiResponse!.response!.statusCode == 200) {
      Map map = apiResponse!.response!.data;
      String token = map["token"];
      await authRepo.saveUserToken(token);
      responseModel = ResponseModel(true, 'Success');
    } else {
      String errorMessage;
      if (apiResponse?.error is String) {
        errorMessage = apiResponse!.error.toString();
      } else {
        // Fallback or better typed error extraction
        errorMessage = apiResponse?.error?.toString() ?? 'An error occurred';
      }
      _loginErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage);
    }
    
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  bool isLoggedIn() {
    return authRepo.isLogin();
  }

  bool logout() {
    return authRepo.logout();
  }
}
