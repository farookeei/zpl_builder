import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// A service class for interacting with the Labelary API to generate label previews.
class LabelaryService {
  static const String _baseUrl = 'https://api.labelary.com/v1/printers';

  /// Renders a ZPL string to a PNG image using the Labelary API.
  /// 
  /// [zpl] The raw ZPL code to render.
  /// [widthInches] Physical width of the label in inches.
  /// [heightInches] Physical height of the label in inches.
  /// [dpmm] Print density in dots per mm (e.g., 8 for 203 DPI). Default is 8.
  static Future<Uint8List> renderZplToPng({
    required String zpl,
    required double widthInches,
    required double heightInches,
    int dpmm = 8,
  }) async {
    final widthStr = widthInches.toStringAsFixed(1);
    final heightStr = heightInches.toStringAsFixed(1);

    final url = Uri.parse('$_baseUrl/${dpmm}dpmm/labels/${widthStr}x${heightStr}/0/');
    
    final response = await http.post(
      url,
      headers: {
        'Accept': 'image/png',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: zpl,
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(
        'Failed to render ZPL via Labelary. Status: ${response.statusCode}\nBody: ${response.body}'
      );
    }
  }
}
