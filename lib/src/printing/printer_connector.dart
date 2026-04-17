import 'dart:async';

/// Represents the connection state of a printer.
enum ZplPrinterConnectionState {
  /// The printer is not connected.
  disconnected,

  /// The printer is currently establishing a connection.
  connecting,

  /// The printer is connected and ready to receive data.
  connected,
}

/// Base class for all printer exceptions.
class ZplPrinterException implements Exception {
  /// The error message.
  final String message;

  /// The inner platform or generic exception that caused this failure, if any.
  final dynamic originalError;

  /// Creates a [ZplPrinterException] with a [message] and optional [originalError].
  ZplPrinterException(this.message, [this.originalError]);

  @override
  String toString() => 'ZplPrinterException: $message ${originalError ?? ''}';
}

/// Abstract contract for any printer connector (Network, Bluetooth, USB, HTTP).
abstract class ZplPrinterConnector {
  /// Default constructor for [ZplPrinterConnector].
  ZplPrinterConnector();

  /// Opens a connection to the printer.
  Future<void> connect();

  /// Closes the connection to the printer.
  Future<void> disconnect();

  /// Sends a ZPL command/string to the printer.
  /// Returns `true` if the data was successfully handed off to the printer/transport.
  Future<bool> send(String zpl);

  /// Returns the current connection state.
  ZplPrinterConnectionState get state;

  /// Returns true if the printer is currently connected.
  bool get isConnected => state == ZplPrinterConnectionState.connected;
}
