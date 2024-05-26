import 'package:equatable/equatable.dart';
import 'package:nasa_apod/models/nasa_image.dart';
import 'package:nasa_apod/models/nasa_video.dart';
import 'package:nasa_apod/utils/date_utils.dart';

abstract class NasaApod extends Equatable {
  final String title;
  final DateTime date;
  final String explanation;
  final String? copyright;

  const NasaApod({
    required this.title,
    required this.date,
    required this.explanation,
    required this.copyright,
  });

  factory NasaApod.fromJson(Map<String, dynamic> json) {
    final mediaType = json['media_type'];

    return switch (mediaType) {
      'image' => NasaImage.fromJson(json),
      'video' => NasaVideo.fromJson(json),
      _ => throw AssertionError('$mediaType not supported'),
    };
  }

  @override
  String toString() {
    return '$runtimeType: ${date.formatForApi()}';
  }
}
