/// A context used during the compilation phase to collect generated ZPL commands.
class ZplContext {
  /// Creates a new [ZplContext].
  ZplContext();

  final StringBuffer _buffer = StringBuffer();

  /// Adds a ZPL [command] to the generated output.
  void addCommand(String command) {
    _buffer.write(command);
  }

  /// Returns the full ZPL string generated during compilation.
  String get zplData => _buffer.toString();
}
