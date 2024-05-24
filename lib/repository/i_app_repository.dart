import 'package:nasa_apod/models/nasa_apod.dart';

abstract class IAppRepository {
  Future<List<NasaApod>> getApods({
    required DateTime startDate,
    required DateTime endDate,
  });
}
