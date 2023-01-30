class LocalNotification {
  static int _ids = 0;

  final int id = _ids++;
  final String title, content, payload;

  LocalNotification(
      {required this.content, required this.title, required this.payload});
}
