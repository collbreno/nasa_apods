import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioUtils {
  static Future<Dio> getAppDio() async {
    await dotenv.load(fileName: '.env');
    final apiKey = dotenv.env['API_KEY'];
    return Dio(BaseOptions(queryParameters: {
      'api_key': apiKey,
    }));
  }
}
