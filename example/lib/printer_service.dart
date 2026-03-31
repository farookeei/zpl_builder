import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ZebraPrinterService {
  /// Sends ZPL data to a Zebra printer via Network Socket (Port 9100)
  static Future<bool> printZPL({
    required String printerIp,
    required String zplCommand,
    int port = 9100,
  }) async {
    try {
      // Connect to the printer socket
      final socket = await Socket.connect(
        printerIp,
        port,
        timeout: const Duration(seconds: 5),
      );

      // Write the ZPL string as UTF-8 bytes
      socket.add(utf8.encode(zplCommand));

      await socket.flush();
      await socket.close();
      return true;
    } catch (e) {
      debugPrint('Zebra Print Error: $e');
      return false;
    }
  }

  static Future<bool> testConnection({required String printerIp}) async {
    try {
      final socket = await Socket.connect(
        printerIp,
        9100,
        timeout: const Duration(seconds: 3),
      );
      await socket.close();
      return true;
    } catch (e) {
      return false;
    }
  }
}
