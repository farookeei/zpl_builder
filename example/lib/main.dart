import 'package:flutter/material.dart';
import 'package:zpl_builder/zpl_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZPL Builder Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const ZplExamplePage(),
    );
  }
}

class ZplExamplePage extends StatefulWidget {
  const ZplExamplePage({super.key});

  @override
  State<ZplExamplePage> createState() => _ZplExamplePageState();
}

class _ZplExamplePageState extends State<ZplExamplePage> {
  String _zplCode = '';

  @override
  void initState() {
    super.initState();
    _generateZpl();
  }

  void _generateZpl() {
    final root = ZplPadding(
      padding: ZplEdgeInsets.all(20),
      child: ZplColumn(
        spacing: 10,
        children: [
          ZplText(
            'SHIPPING LABEL',
            font: ZplFont(fontName: '0', height: 40, width: 40),
          ),
          ZplText('To: John Doe'),
          ZplText('123 Main St'),
          ZplText('New York, NY 10001'),
          ZplBarcode('123456789', type: ZplBarcodeType.code128, height: 100),
        ],
      ),
    );

    setState(() {
      _zplCode = ZplBuilder.build(root);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZPL Builder Example'), elevation: 2),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Generated ZPL:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _zplCode,
                    style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _generateZpl,
              icon: const Icon(Icons.refresh),
              label: const Text('Regenerate ZPL'),
            ),
          ],
        ),
      ),
    );
  }
}
