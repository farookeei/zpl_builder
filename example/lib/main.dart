import 'package:flutter/material.dart';
import 'package:zpl_kit/zpl_kit.dart';
import 'printer_service.dart';

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
  ZplLabelSize _selectedSize = ZplLabelSize.shipping4x6;
  late final TextEditingController _widthController;
  late final TextEditingController _heightController;
  final TextEditingController _ipController = TextEditingController(text: '172.17.9.11');
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    _widthController = TextEditingController(
      text: _selectedSize.width.toString(),
    );
    _heightController = TextEditingController(
      text: _selectedSize.height.toString(),
    );
    _generateZpl();
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _generateZpl() {
    final root = ZplPadding(
      padding: ZplEdgeInsets.all(20),
      child: ZplColumn(
        crossAxisAlignment: ZplCrossAxisAlignment.start,
        children: [
          // Section 1: Logo & Title
          ZplRow(
            spacing: 30,
            children: [
              ZplStack(
                children: [
                  ZplGraphicBox(width: 100, height: 100, thickness: 100),
                  ZplPadding(
                    padding: ZplEdgeInsets.all(25),
                    child: ZplGraphicBox(width: 50, height: 50, thickness: 50, reversePrint: true),
                  ),
                  ZplPadding(
                    padding: ZplEdgeInsets.all(42),
                    child: ZplGraphicBox(width: 16, height: 16, thickness: 16),
                  ),
                ],
              ),
              ZplColumn(
                crossAxisAlignment: ZplCrossAxisAlignment.start,
                children: [
                  ZplText(
                    'Intershipping, Inc.',
                    font: ZplFont.helvetica(size: 60),
                  ),
                  ZplText('1000 Shipping Lane', font: ZplFont.helvetica(size: 35)),
                  ZplText('Shelbyville TN 38102', font: ZplFont.helvetica(size: 35)),
                  ZplText('United States (USA)', font: ZplFont.helvetica(size: 35)),
                ],
              ),
            ],
          ),

          ZplPadding(
            padding: ZplEdgeInsets.symmetric(vertical: 20),
            child: ZplGraphicBox(width: 760, height: 3, thickness: 3),
          ),

          // Section 2: Address & Permit (Using Stack for precise positioning)
          ZplStack(
            children: [
              // Address stays on the left
              ZplColumn(
                crossAxisAlignment: ZplCrossAxisAlignment.start,
                children: [
                  ZplText('John Doe', font: ZplFont.helvetica(size: 40)),
                  ZplText('100 Main Street', font: ZplFont.helvetica(size: 40)),
                  ZplText('Springfield TN 39021', font: ZplFont.helvetica(size: 40)),
                  ZplText('United States (USA)', font: ZplFont.helvetica(size: 40)),
                ],
              ),
              // Permit Box positioned absolutely at X=580
              ZplPadding(
                padding: ZplEdgeInsets.only(left: 550),
                child: ZplStack(
                  children: [
                    ZplGraphicBox(width: 170, height: 170, thickness: 3),
                    ZplPadding(
                      padding: ZplEdgeInsets.only(top: 45, left: 35),
                      child: ZplColumn(
                        children: [
                          ZplText('Permit', font: ZplFont(fontName: 'A', height: 30, width: 30)),
                          ZplText('123456', font: ZplFont(fontName: 'A', height: 30, width: 30)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ZplPadding(
            padding: ZplEdgeInsets.symmetric(vertical: 20),
            child: ZplGraphicBox(width: 760, height: 3, thickness: 3),
          ),

          // Section 3: Large Barcode
          ZplPadding(
            padding: ZplEdgeInsets.only(left: 70, top: 20),
            child: ZplBarcode(
              '12345678',
              height: 270,
              widthRatio: 5,
              printText: true,
            ),
          ),

          ZplPadding(
            padding: ZplEdgeInsets.only(top: 80),
            child: ZplGraphicBox(width: 0, height: 0),
          ),

          // Section 4: Bottom Split Box
          ZplStack(
            children: [
              ZplGraphicBox(width: 760, height: 250, thickness: 3),
              ZplPadding(
                padding: ZplEdgeInsets.only(left: 380),
                child: ZplGraphicBox(width: 3, height: 250, thickness: 3),
              ),
              // Left Column
              ZplPadding(
                padding: ZplEdgeInsets.all(35),
                child: ZplColumn(
                  crossAxisAlignment: ZplCrossAxisAlignment.start,
                  children: [
                    ZplText('Ctr. X34B-1', font: ZplFont.helvetica(size: 45)),
                    ZplText('REF1 F00B47', font: ZplFont.helvetica(size: 45)),
                    ZplText('REF2 BL4H8', font: ZplFont.helvetica(size: 45)),
                  ],
                ),
              ),
              // "CA" centered in the right half (starts at 380, width 380)
              ZplPadding(
                padding: ZplEdgeInsets.only(left: 450, top: 40),
                child: ZplText(
                  'CA',
                  font: ZplFont.helvetica(size: 195),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final width = int.tryParse(_widthController.text) ?? 800;
    final height = int.tryParse(_heightController.text) ?? 600;

    setState(() {
      _zplCode = ZplKit.build(root, labelSize: ZplLabelSize(width, height));
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
              'Label Settings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: DropdownButtonFormField<ZplLabelSize>(
                    value: _selectedSize,
                    decoration: const InputDecoration(
                      labelText: 'Standard Size',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: ZplLabelSize.commonSizes.map((size) {
                      return DropdownMenuItem(
                        value: size,
                        child: Text(size.name, style: TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSize = value;
                          _widthController.text = value.width.toString();
                          _heightController.text = value.height.toString();
                        });
                        _generateZpl();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _widthController,
                    decoration: const InputDecoration(
                      labelText: 'Width (Dots)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _generateZpl(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _heightController,
                    decoration: const InputDecoration(
                      labelText: 'Height (Dots)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _generateZpl(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generateZpl,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Regenerate ZPL'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _ipController,
                    decoration: const InputDecoration(
                      labelText: 'Printer IP Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.print),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isPrinting ? null : _printToPrinter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: _isPrinting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('PRINT TO ZEBRA'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _printToPrinter() async {
    setState(() => _isPrinting = true);
    final success = await ZebraPrinterService.printZPL(
      printerIp: _ipController.text,
      zplCommand: _zplCode,
    );
    if (mounted) {
      setState(() => _isPrinting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Label Sent to Printer' : 'Printing Failed'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}
