import 'package:flutter/material.dart';
import 'package:nasa_apod/models/nasa_apod.dart';

abstract class IAppRepository {
  Future<List<NasaApod>> getApods(DateTimeRange dateRange);
}
