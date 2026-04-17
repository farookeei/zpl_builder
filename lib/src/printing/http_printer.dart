import 'dart:developer';

import 'package:http/http.dart' as http;
import 'printer_connector.dart';

/// A printer connector that communicates over HTTP/REST.
/// Useful for Web environments or printers behind an HTTP proxy.
class HttpZplPrinter extends ZplPrinterConnector {
  /// The base URL of the HTTP printer.
  final Uri baseUrl;

  /// Optional HTTP headers to include in the requests.
  final Map<String, String>? headers;

  ZplPrinterConnectionState _state = ZplPrinterConnectionState.disconnected;

  /// Creates an [HttpZplPrinter] with a [baseUrl] and optional [headers].
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
    final requestUrl = Uri.parse('$base/pstprnt');

    try {
      final Map<String, String> requestHeaders = {
        'Content-Type': 'text/plain',
        ...?headers,
      };

      log('Sending ZPL to: $requestUrl');

      final response = await http.post(
        requestUrl,
        headers: requestHeaders,
        body: zpl,
      );

      log('Response Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true; // Print success
      } else {
        throw ZplPrinterException(
          'Printer returned HTTP ${response.statusCode}. Body: ${response.body}',
        );
      }
    } catch (e) {
      throw ZplPrinterException('HTTP print failed: $e');
    }
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
