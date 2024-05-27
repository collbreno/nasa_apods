import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod/utils/date_utils.dart';

void main() {
  test('testing formatForApi method', () {
    expect(DateTime(2024, 5, 20).formatForApi(), '2024-05-20');
    expect(DateTime(2024, 1, 1).formatForApi(), '2024-01-01');
    expect(DateTime(2024, 12, 30).formatForApi(), '2024-12-30');
  });

  test('testing formatForUser method', () {
    expect(DateTime(2024, 5, 20).formatForUser(), 'May 20, 2024');
    expect(DateTime(2024, 1, 1).formatForUser(), 'Jan 1, 2024');
    expect(DateTime(2024, 12, 30).formatForUser(), 'Dec 30, 2024');
  });
}
