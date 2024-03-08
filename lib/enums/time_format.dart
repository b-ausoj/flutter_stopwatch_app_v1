enum TimeFormat {
  mmssds("mm:ss.ds"),
  hhmmss("hh:mm:ss");
  const TimeFormat(this.value);
  final String value;
}