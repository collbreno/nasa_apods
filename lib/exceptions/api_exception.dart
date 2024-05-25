class ApiException implements Exception {
  final String msg;

  ApiException(this.msg);

  @override
  String toString() {
    return 'Api error: $msg';
  }
}
