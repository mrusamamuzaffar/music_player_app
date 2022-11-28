extension DurationExtensions on Duration {
  String get timeFormat {
    String minute = int.parse(toString().split('.').first.padLeft(8, "0").split(':')[1]).toString();
    String second = toString().split('.').first.padLeft(8, "0").split(':')[2];
    return ("$minute:$second");
  }
}
