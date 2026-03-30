class ZplContext {
  final StringBuffer _buffer = StringBuffer();

  void addCommand(String command) {
    _buffer.write(command);
  }

  String get zplData => _buffer.toString();
}
