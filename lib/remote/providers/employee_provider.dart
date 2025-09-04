import 'package:app/remote/models/client_model.dart';
import 'package:app/remote/models/history_model.dart';
import 'package:app/remote/repositories/employee_repository.dart';
import 'package:app/remote/response/api_response.dart';
import 'package:app/remote/response/response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class EmployeeProvider extends ChangeNotifier {
  ResponseModel? responseModel;
  ApiResponse? apiResponse;
  EmployeeRepo? employeeRepo;
  EmployeeProvider({this.employeeRepo});

  List<ClientModel>? _clients;
  List<ClientModel>? get clients => _clients;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitLoading = false;
  bool get isSubmitLoading => _isSubmitLoading;

  List<HistoryModel>? _history;
  List<HistoryModel>? get history => _history;

  bool _isHistoryLoading = false;
  bool get isHistoryLoading => _isHistoryLoading;

  bool _isTMRSubmitLoading = false;
  bool get isTMRSubmitLoading => _isTMRSubmitLoading;

  bool _isStartVisitLoading = false;
  bool get isStartVisitLoading => _isStartVisitLoading;

  String? _startVisitErrorMessage;
  String? get startVisitErrorMessage => _startVisitErrorMessage;

  ClientModel? _client;
  ClientModel? get client => _client;

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

  Future<ResponseModel?> submitSalesActivities(
      List<String> activities, String clientId) async {
    _isSubmitLoading = true;
    notifyListeners();
    apiResponse =
        await employeeRepo!.submitSalesActivities(activities, clientId);
    if (apiResponse!.response != null &&
        apiResponse!.response!.statusCode == 200) {
      responseModel = ResponseModel(true, 'Success');
      _isSubmitLoading = false;
    } else {
      responseModel =
          ResponseModel(false, apiResponse!.response!.data['message']);
      _isSubmitLoading = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel?> submitTMRActivities(
      List<String> images, String clientId, String note) async {
    _isTMRSubmitLoading = true;
    notifyListeners();
    apiResponse =
        await employeeRepo!.submitTMRActivities(images, clientId, note);
    if (apiResponse!.response != null &&
        apiResponse!.response!.statusCode == 200) {
      responseModel = ResponseModel(true, 'Success');
      _isTMRSubmitLoading = false;
    } else {
      responseModel =
          ResponseModel(false, apiResponse!.response!.data['message']);
      _isTMRSubmitLoading = false;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel?> startVisit(String barcode) async {
    _isStartVisitLoading = true;
    notifyListeners();
    var locationData = await Geolocator.getCurrentPosition();

    apiResponse = await employeeRepo!.startVisit(
      locationData.latitude,
      locationData.longitude,
      barcode,
    );
    if (apiResponse!.response != null &&
        apiResponse!.response!.statusCode == 200) {
      responseModel = ResponseModel(true, 'Success');
      _isStartVisitLoading = false;
      _client = ClientModel.fromJson(apiResponse!.response!.data['data']);
    } else {
      responseModel = ResponseModel(false, apiResponse!.error);
      _isStartVisitLoading = false;
    }
    notifyListeners();
    return responseModel;
  }
}
