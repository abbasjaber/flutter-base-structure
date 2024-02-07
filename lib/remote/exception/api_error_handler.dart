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
                case 400:
                  return 'Bad request.';
                case 401:
                  return 'Authentication failed.';
                case 403:
                  return 'The authenticated user is not allowed to access the specified API endpoint.';
                case 404:
                  return 'The requested resource does not exist.';
                case 405:
                  return 'Method not allowed. Please check the Allow header for the allowed HTTP methods.';
                case 415:
                  return 'Unsupported media type. The requested content type or version number is invalid.';
                case 422:
                  return 'Data validation failed.';
                case 429:
                  return 'Too many requests.';
                case 500:
                  return 'Internal server error.';
                default:
                  return 'Oops something went wrong!';
              }
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
            case DioExceptionType.badCertificate:
              errorDescription = "Bad Certificate";
              break;
            case DioExceptionType.unknown:
              if (error.message!.contains('SocketException')) {
                errorDescription = 'No Internet.';
                break;
              }
              errorDescription = 'Unexpected error occurred.';
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
    print(errorDescription);
    return tr(errorDescription);
  }
}
