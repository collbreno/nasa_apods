import 'package:nasa_apod/models/nasa_apod.dart';

class NasaVideo extends NasaApod {
  final String thumbUrl;
  final String videoUrl;

  NasaVideo.fromJson(Map<String, dynamic> json)
      : videoUrl = json['url'],
        thumbUrl = json['thumbnail_url'],
        super(
          copyright: json['copyright'],
          title: json['title'],
          date: DateTime.parse(json['date']),
          explanation: json['explanation'],
        );

  @override
  List<Object?> get props => [
        videoUrl,
        thumbUrl,
        copyright,
        title,
        date,
        explanation,
      ];
}
