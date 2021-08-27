import 'dart:async';
import '/util/common/common.dart';
import 'package:dio/dio.dart';
import '../models/common/error_model.dart';
import '../util/common/logger.dart';
import '../util/constants/locale_keys.dart';
import 'url_api.dart';

abstract class Constants {
  static const contentType = "application/json";
}

enum MethodType { GET, POST, PATCH, DELETE }

Map<MethodType, String> methods = {
  MethodType.GET: "GET",
  MethodType.POST: "POST",
  MethodType.PATCH: "PATCH",
  MethodType.DELETE: "DELETE",
};

class Request {
  Dio _dio = Dio();

  Request({String? base}) {
    if (base == null) base = environment.apiUrl;
    _dio = Dio(BaseOptions(
        baseUrl: base,
        receiveTimeout: environment.receiveTimeout,
        connectTimeout: environment.connectTimeout,
        contentType: Constants.contentType));
  }

  Future<Object> requestApi({
    required MethodType method,
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? header,
  }) async {
    Logger.info("URL: " + url + "\n" + "body: " + data.toString());
    try {
      var response = await _dio.request(
        url,
        data: data,
        options: Options(method: methods[method], headers: header),
      );
      Logger.info("Response: " + response.toString());
      return response.data;
    } catch (e) {
      Logger.error(e.toString());
      return handleError(e);
    }
  }

  Future<ErrorModel> handleError(dynamic error) async {
    ErrorModel errorModel = ErrorModel();
    errorModel.message = error.toString();
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.sendTimeout:
          errorModel.type = ErrorType.TIME_OUT;
          errorModel.description = LocaleKeys.request_send_timeout;
          break;
        case DioErrorType.connectTimeout:
          errorModel.type = ErrorType.TIME_OUT;
          errorModel.description = LocaleKeys.request_connect_timeout;
          break;
        case DioErrorType.receiveTimeout:
          errorModel.type = ErrorType.TIME_OUT;
          errorModel.description = LocaleKeys.request_receive_timeout;
          break;
        case DioErrorType.cancel:
          errorModel.type = ErrorType.CANCELLED;
          errorModel.description = LocaleKeys.request_cancelled;
          break;
        case DioErrorType.other:
          errorModel.type = ErrorType.NO_INTERNET;
          errorModel.description = LocaleKeys.no_internet;
          break;
        case DioErrorType.response:
          Logger.error(error.response!.toString());
          try {
            errorModel.type = ErrorType.UNKNOWN;
            errorModel.code = error.response!.statusCode ?? errorModel.code;
            errorModel.description =
                error.response!.data ?? errorModel.description;
          } catch (e) {
            Logger.error(e.toString());
          }
          break;
      }
    }
    if (errorModel.code == 401) {
      Common.showToast(msg: "Lỗi!");
    }
    return errorModel;
  }
}
