import 'package:app/remote/models/client_model.dart';
import 'package:app/remote/models/history_model.dart';
import 'package:app/remote/repositories/employee_repository.dart';
import 'package:app/remote/response/api_response.dart';
import 'package:app/remote/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class EmployeeProvider extends ChangeNotifier {
  ResponseModel? responseModel;
  ApiResponse? apiResponse;
  EmployeeRepo? employeeRepo;
  EmployeeProvider({this.employeeRepo});

  List<ClientModel>? _clients;
  List<ClientModel>? get clients => _clients;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<HistoryModel>? _history;
  List<HistoryModel>? get history => _history;

  bool _isHistoryLoading = false;
  bool get isHistoryLoading => _isHistoryLoading;

  Future<ResponseModel?> getClients() async {
    _clients = [];
    _isLoading = true;
    apiResponse = await employeeRepo!.getClients();
    if (apiResponse!.response != null &&
        apiResponse!.response!.statusCode == 200) {
      _clients?.clear();
      _clients = (apiResponse!.response!.data['data'] as List)
          .map((e) => ClientModel.fromJson(e))
          .toList();
      responseModel = ResponseModel(true, 'Success');
      _isLoading = false;
    } else {
      responseModel =
          ResponseModel(false, apiResponse!.response!.data['message']);
      _isLoading = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel?> getHistory() async {
    _history = [];
    _isHistoryLoading = true;
    apiResponse = await employeeRepo!.getHistory();
    if (apiResponse!.response != null &&
        apiResponse!.response!.statusCode == 200) {
      _history?.clear();
      _history = (apiResponse!.response!.data['data'] as List)
          .map((e) => HistoryModel.fromJson(e))
          .toList();
      responseModel = ResponseModel(true, 'Success');
      _isHistoryLoading = false;
    } else {
      responseModel =
          ResponseModel(false, apiResponse!.response!.data['message']);
      _isHistoryLoading = false;
    }
    notifyListeners();
    return responseModel;
  }
}
