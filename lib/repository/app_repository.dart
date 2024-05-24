import 'package:dio/dio.dart';
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
    final response = await dio.get(
      'https://api.nasa.gov/planetary/apod',
      queryParameters: {
        'thumbs': true,
        'start_date': startDate.formatForApi(),
        'end_date': endDate.formatForApi(),
      },
    );

    final list = response.data as List<dynamic>;

    return list.map((e) => NasaApod.fromJson(e)).toList();
  }
}
