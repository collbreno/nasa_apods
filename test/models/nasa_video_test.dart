import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/models/nasa_video.dart';

import '../test_utils/file_utils.dart';

void main() {
  test('testing $NasaVideo fromJson constructor (with copyright)', () async {
    final json = await FileUtils.loadFile('video_example.json');
    final apod = NasaApod.fromJson(json);

    expect(apod, isA<NasaVideo>());

    final video = apod as NasaVideo;
    expect(video.copyright, isNotNull);
    expect(video.copyright, json['copyright']);
    expect(video.videoUrl, json['url']);
    expect(video.thumbUrl, json['thumbnail_url']);
    expect(video.title, json['title']);
    expect(video.date, DateTime.parse(json['date']));
    expect(video.explanation, json['explanation']);
  });

  test('testing $NasaVideo fromJson constructor (without copyright)', () async {
    final json = await FileUtils.loadFile('video_no_copr_example.json');
    final video = NasaApod.fromJson(json);

    expect(video, isA<NasaVideo>());
    expect(video.copyright, isNull);
  });
}
