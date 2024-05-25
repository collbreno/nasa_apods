import 'package:dio/dio.dart';
import 'package:nasa_apod/exceptions/api_exception.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/repository/i_app_repository.dart';
import 'package:nasa_apod/utils/date_utils.dart';

class AppRepository extends IAppRepository {
  final Dio dio;

  AppRepository(this.dio);

  @override
  Future<List<NasaApod>> getApods({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await dio.get(
        'https://api.nasa.gov/planetary/apod',
        queryParameters: {
          'thumbs': true,
          'start_date': startDate.formatForApi(),
          'end_date': endDate.formatForApi(),
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 20),
        ),
      );

      final list = response.data as List<dynamic>;

      return list.map((e) => NasaApod.fromJson(e)).toList().reversed.toList();
    } on Exception catch (e) {
      if (e is DioException &&
          e.response != null &&
          e.response!.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data['msg'] != null) {
          throw ApiException(data['msg']);
        }
      }
      rethrow;
    }
  }
}
