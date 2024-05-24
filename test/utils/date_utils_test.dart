import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/utils/date_utils.dart';

void main() {
  test('formatForApi', () {
    expect(DateTime(2024, 5, 20).formatForApi(), '2024-05-20');
    expect(DateTime(2024, 1, 1).formatForApi(), '2024-01-01');
    expect(DateTime(2024, 12, 30).formatForApi(), '2024-12-30');
  });
}
