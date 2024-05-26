import 'package:flutter/material.dart';
import 'package:nasa_apod/models/nasa_apod.dart';

import '../test_utils/file_utils.dart';

class ApodListFixture {
  final List<NasaApod> apods;
  ApodListFixture.fromJson(dynamic file)
      : apods =
            (file as List<dynamic>).map((e) => NasaApod.fromJson(e)).toList();

  static Future<ApodListFixture> loadFromMarch() async {
    final json = await FileUtils.loadFile('apod_list_2024-march.json');
    return ApodListFixture.fromJson(json);
  }

  NasaApod fromDate(DateTime date) =>
      apods.firstWhere((element) => element.date == date);

  List<NasaApod> fromRange(DateTimeRange range) {
    final list = <NasaApod>[];
    DateTime date = range.start;
    list.add(fromDate(date));
    while (date.isBefore(range.end)) {
      date = date.add(const Duration(days: 1));
      list.add(fromDate(date));
    }
    return list;
  }
}
