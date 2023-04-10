class HTTPExceprion implements Exception {
  final String message;

  HTTPExceprion(this.message);

  @override
  String toString() {
    return message;
    // return super.toString();
  }
}
