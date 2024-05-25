import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:nasa_apod/exceptions/api_exception.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/models/nasa_image.dart';
import 'package:nasa_apod/models/nasa_video.dart';
import 'package:nasa_apod/repository/app_repository.dart';
import 'package:nasa_apod/repository/i_app_repository.dart';
import 'package:nasa_apod/utils/dio_utils.dart';

import '../test_utils/file_utils.dart';

void main() {
  group('mocked dio', () {
    late IAppRepository repository;
    late DioAdapter dioAdapter;

    setUp(() {
      dioAdapter = DioAdapter(dio: Dio());
      repository = AppRepository(dioAdapter.dio);
    });

    test('simple list', () async {
      final json = await FileUtils.loadFile(
        'test/assets/apod_list_example.json',
      );
      dioAdapter.onGet('https://api.nasa.gov/planetary/apod', (server) {
        server.reply(200, json);
      });

      final result = await repository.getApods(
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );

      expect(result, isA<List<NasaApod>>());
      expect(result, hasLength(4));
      expect(result[0], isA<NasaVideo>());
      expect(result[1], isA<NasaImage>());
      expect(result[2], isA<NasaImage>());
      expect(result[3], isA<NasaImage>());
    });

    test('invalid date range', () async {
      final json = await FileUtils.loadFile(
        'test/assets/apod_list_invalid_date_range.json',
      );
      dioAdapter.onGet('https://api.nasa.gov/planetary/apod', (server) {
        server.reply(400, json);
      });

      expect(
        () async => await repository.getApods(
          startDate: DateTime.now(),
          endDate: DateTime.now(),
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });
  group('real api call', () {
    late IAppRepository repository;

    setUp(() async {
      final dio = await DioUtils.getAppDio();
      repository = AppRepository(dio);
    });

    test('simple list', () async {
      final list = await repository.getApods(
        startDate: DateTime(2024, 5, 10),
        endDate: DateTime(2024, 5, 12),
      );

      expect(list, hasLength(3));
      expect(list, isA<List<NasaApod>>());
      expect(
          list.map((e) => e.date),
          orderedEquals([
            DateTime(2024, 5, 12),
            DateTime(2024, 5, 11),
            DateTime(2024, 5, 10),
          ]));
    });

    test('invalid date range', () async {
      expect(
        () async => await repository.getApods(
          startDate: DateTime(1900, 1, 1),
          endDate: DateTime.now(),
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
