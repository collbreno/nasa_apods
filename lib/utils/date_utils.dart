import 'package:intl/intl.dart';

extension DateUtilsExtension on DateTime {
  String formatForApi() => DateFormat('yyyy-MM-dd').format(this);
  String formatForUser() => DateFormat.yMMMd().format(this);
}
