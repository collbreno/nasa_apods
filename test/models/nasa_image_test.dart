import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/models/nasa_apod.dart';
import 'package:nasa_apod/models/nasa_image.dart';

import '../test_utils/file_utils.dart';

void main() {
  test('nasa image with copyright', () async {
    final json = await FileUtils.loadFile('test/assets/image_example.json');
    final image = NasaApod.fromJson(json);

    expect(image, isA<NasaImage>());
    expect(image.copyright, isNotNull);
  });

  test('nasa image without copyright', () async {
    final json =
        await FileUtils.loadFile('test/assets/image_no_copr_example.json');
    final image = NasaApod.fromJson(json);

    expect(image, isA<NasaImage>());
    expect(image.copyright, isNull);
  });
}
