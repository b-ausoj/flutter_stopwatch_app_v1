enum CSVDelimiter {
  comma("Comma", ","),
  semicolon("Semicolon", ";"),
  tab("Tab", "\t"),
  pipe("Pipe", "|"),
  space("Space", " ");

  final String label;
  final String delimiter;

  const CSVDelimiter(this.label, this.delimiter);
}
