import 'package:http/http.dart' as http;
import 'printer_connector.dart';

/// A printer connector that communicates over HTTP/REST.
/// Useful for Web environments or printers behind an HTTP proxy.
class HttpZplPrinter extends ZplPrinterConnector {
  final Uri endpoint;
  final Map<String, String>? headers;

  ZplPrinterConnectionState _state = ZplPrinterConnectionState.disconnected;

  HttpZplPrinter({
    required this.endpoint,
    this.headers,
  });

  @override
  ZplPrinterConnectionState get state => _state;

  @override
  Future<void> connect() async {
    // HTTP is stateless, but we can verify the endpoint is reachable if needed.
    // For now, we'll just mark as connected.
    _state = ZplPrinterConnectionState.connected;
  }

  @override
  Future<void> disconnect() async {
    _state = ZplPrinterConnectionState.disconnected;
  }

  @override
  Future<bool> send(String zpl) async {
    try {
      final response = await http.post(
        endpoint,
        headers: headers ?? {'Content-Type': 'text/plain'},
        body: zpl,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        throw ZplPrinterException(
          'HTTP Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw ZplPrinterException('Failed to send ZPL via HTTP', e);
    }
  }

  /// Convenience method to send ZPL via HTTP POST.
  static Future<bool> printOnce({
    required Uri endpoint,
    required String zpl,
    Map<String, String>? headers,
  }) async {
    final printer = HttpZplPrinter(endpoint: endpoint, headers: headers);
    await printer.connect();
    return await printer.send(zpl);
  }
}
