import 'dart:convert';
import 'dart:io';
import 'printer_connector.dart';

/// A printer connector that communicates over TCP/IP (Socket).
/// Usually works on port 9100 for Zebra printers.
class TcpZplPrinter extends ZplPrinterConnector {
  /// The host IP or hostname of the printer.
  final String host;

  /// The port for the printer. Defaults to 9100.
  final int port;

  /// The maximum duration to wait for a connection attempt.
  final Duration timeout;

  Socket? _socket;
  ZplPrinterConnectionState _state = ZplPrinterConnectionState.disconnected;

  /// Creates a [TcpZplPrinter] with the target [host], and optional [port] and [timeout].
  TcpZplPrinter({
    required this.host,
    this.port = 9100,
    this.timeout = const Duration(seconds: 5),
  });

  @override
  ZplPrinterConnectionState get state => _state;

  @override
  Future<void> connect() async {
    if (_state == ZplPrinterConnectionState.connected) return;

    _state = ZplPrinterConnectionState.connecting;
    try {
      _socket = await Socket.connect(host, port, timeout: timeout);
      _state = ZplPrinterConnectionState.connected;
    } catch (e) {
      _state = ZplPrinterConnectionState.disconnected;
      throw ZplPrinterException('Failed to connect to $host:$port', e);
    }
  }

  @override
  Future<void> disconnect() async {
    await _socket?.close();
    _socket = null;
    _state = ZplPrinterConnectionState.disconnected;
  }

  @override
  Future<bool> send(String zpl) async {
    final socket = _socket;
    if (socket == null || _state != ZplPrinterConnectionState.connected) {
      // Auto-connect if not connected? For now, let's keep it explicit or throw.
      throw ZplPrinterException('Printer not connected');
    }

    try {
      socket.add(utf8.encode(zpl));
      await socket.flush();
      return true;
    } catch (e) {
      throw ZplPrinterException('Failed to send ZPL data', e);
    }
  }

  /// Convenience method to connect, send, and disconnect in one go.
  static Future<bool> printOnce({
    required String host,
    required String zpl,
    int port = 9100,
  }) async {
    final printer = TcpZplPrinter(host: host, port: port);
    try {
      await printer.connect();
      final result = await printer.send(zpl);
      await printer.disconnect();
      return result;
    } catch (_) {
      return false;
    }
  }
}
