enum TimeFormat {
  mmsshs("mm:ss.hs"),
  hhmmss("hh:mm:ss");
  const TimeFormat(this.value);
  final String value;
}