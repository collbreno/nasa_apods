import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nasa_apod/exceptions/api_exception.dart';

class ExceptionUtils {
  static String getExceptionMessageText(Object error) {
    if (error is ApiException) {
      return error.msg;
    }
    if (error is DioException) {
      final innerError = error.error;
      if (innerError is SocketException) {
        return innerError.message;
      }
      return error.message ?? error.toString();
    }
    if (error is Exception) {
      return error.toString();
    } else {
      return 'Something got wrong';
    }
  }
}
