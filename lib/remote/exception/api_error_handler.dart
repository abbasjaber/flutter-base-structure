import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
//import 'package:almahboub/data/model/response/base/error_response.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.connectionError:
              errorDescription =
                  "Connection Lost. Please check your Internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription =
                  "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 404:
                  errorDescription = "Request is not found.";
                  break;
                case 422:
                  errorDescription = "Request is unAuthorized.";
                  break;
                case 403:
                case 500:
                case 503:
                  errorDescription = error.response!.data;
                  break;
                default:
                // ErrorResponse errorResponse =
                //     ErrorResponse.fromJson(error.response.data);
                // if (errorResponse.errors != null &&
                //     errorResponse.errors.length > 0)
                //   errorDescription = errorResponse;
                // else
                //   errorDescription =
                //       "Failed to load data - status code: ${error.response.statusCode}";
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            case DioExceptionType.badCertificate:
              errorDescription = "Bad Certificate";
              break;
            case DioExceptionType.unknown:
              errorDescription = "Connection timeout with API server";
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return tr(errorDescription);
  }
}
