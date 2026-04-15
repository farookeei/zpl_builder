import 'package:http/http.dart' as http;
import 'printer_connector.dart';

/// A printer connector that communicates over HTTP/REST.
/// Useful for Web environments or printers behind an HTTP proxy.
class HttpZplPrinter extends ZplPrinterConnector {
  final Uri baseUrl;
  final Map<String, String>? headers;

  ZplPrinterConnectionState _state = ZplPrinterConnectionState.disconnected;

  HttpZplPrinter({
    required this.baseUrl,
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
    final String base = baseUrl.toString().replaceAll(RegExp(r'/$'), '');

    final attempts = [
      {
        'name': '/pstprnt',
        'url': Uri.parse('$base/pstprnt'),
        'headers': {'Content-Type': 'text/plain'},
        'body': zpl,
      },
      {
        'name': '/zpl',
        'url': Uri.parse('$base/zpl'),
        'headers': {'Content-Type': 'application/x-www-form-urlencoded'},
        'body': 'zpl=${Uri.encodeComponent(zpl)}',
      },
      {
        'name': '/print',
        'url': Uri.parse('$base/print'),
        'headers': {'Content-Type': 'text/plain'},
        'body': zpl,
      },
      {
        'name': '/ (root)',
        'url': Uri.parse('$base/'),
        'headers': {'Content-Type': 'application/octet-stream'},
        'body': zpl,
      },
    ];

    final List<String> errors = [];

    for (final attempt in attempts) {
      try {
        final Map<String, String> requestHeaders = Map<String, String>.from(headers ?? {});
        // Fallback to the attempt's default header if the user hasn't provided it
        (attempt['headers'] as Map<String, String>).forEach((key, value) {
          requestHeaders.putIfAbsent(key, () => value);
        });

        final response = await http.post(
          attempt['url'] as Uri,
          headers: requestHeaders,
          body: attempt['body'] as String,
        );

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return true; // Print success
        } else {
          errors.add('${attempt['name']} returned HTTP ${response.statusCode}');
        }
      } catch (e) {
        errors.add('${attempt['name']} failed: $e');
      }
    }

    throw ZplPrinterException(
      'All HTTP endpoints failed. Errors: ${errors.join(', ')}',
    );
  }

  /// Convenience method to send ZPL via HTTP POST.
  static Future<bool> printOnce({
    required Uri baseUrl,
    required String zpl,
    Map<String, String>? headers,
  }) async {
    final printer = HttpZplPrinter(baseUrl: baseUrl, headers: headers);
    await printer.connect();
    return await printer.send(zpl);
  }
}
