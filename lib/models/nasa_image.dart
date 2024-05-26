import 'package:nasa_apod/models/nasa_apod.dart';

class NasaImage extends NasaApod {
  final String hdUrl;
  final String imageUrl;

  NasaImage.fromJson(Map<String, dynamic> json)
      : hdUrl = json['hdurl'],
        imageUrl = json['url'],
        super(
          copyright: json['copyright'],
          title: json['title'],
          date: DateTime.parse(json['date']),
          explanation: json['explanation'],
        );

  @override
  List<Object?> get props => [
        hdUrl,
        imageUrl,
        copyright,
        title,
        date,
        explanation,
      ];
}
