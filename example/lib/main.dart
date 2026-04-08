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
      title: 'ZPL Kit Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
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
  ZplComponent? _lastRoot;
  ZplLabelSize _selectedSize = ZplLabelSize.shipping4x6;
  late final TextEditingController _widthController;
  late final TextEditingController _heightController;
  final TextEditingController _ipController = TextEditingController(
    text: '172.17.9.11',
  );
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

  ZplComponent _buildRoot() {
    return ZplPadding(
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
                    child: ZplGraphicBox(
                      width: 50,
                      height: 50,
                      thickness: 50,
                      reversePrint: true,
                    ),
                  ),
                  ZplPadding(
                    padding: ZplEdgeInsets.all(42),
                    child: ZplGraphicBox(width: 16, height: 16, thickness: 16),
                  ),
                ],
              ),
              ZplExpanded(
                child: ZplColumn(
                  crossAxisAlignment: ZplCrossAxisAlignment.start,
                  children: [
                    ZplText(
                      'Intershipping, Inc.',
                      font: ZplFont.helvetica(size: 60),
                    ),
                    ZplText(
                      '1000 Shipping Lane',
                      font: ZplFont.helvetica(size: 35),
                    ),
                    ZplText(
                      'Shelbyville TN 38102',
                      font: ZplFont.helvetica(size: 35),
                    ),
                    ZplText(
                      'United States (USA)',
                      font: ZplFont.helvetica(size: 35),
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

          // Section 2: Address & Permit
          ZplStack(
            children: [
              ZplColumn(
                crossAxisAlignment: ZplCrossAxisAlignment.start,
                children: [
                  ZplText('John Doe', font: ZplFont.helvetica(size: 40)),
                  ZplText('100 Main Street', font: ZplFont.helvetica(size: 40)),
                  ZplText(
                    'Springfield TN 39021',
                    font: ZplFont.helvetica(size: 40),
                  ),
                  ZplText(
                    'United States (USA)',
                    font: ZplFont.helvetica(size: 40),
                  ),
                ],
              ),
              ZplPadding(
                padding: ZplEdgeInsets.only(left: 550),
                child: ZplStack(
                  children: [
                    ZplGraphicBox(width: 200, height: 170, thickness: 3),
                    ZplPadding(
                      padding: ZplEdgeInsets.only(top: 45, left: 35),
                      child: ZplColumn(
                        children: [
                          ZplText(
                            'Permit',
                            font: ZplFont(fontName: 'A', height: 20, width: 20),
                          ),
                          ZplText(
                            '123456',
                            font: ZplFont(fontName: 'A', height: 20, width: 20),
                          ),
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
          ZplCenter(
            child: ZplPadding(
              padding: ZplEdgeInsets.only(top: 20),
              child: ZplBarcode(
                '12345678',
                height: 270,
                widthRatio: 5,
                printText: true,
              ),
            ),
          ),
          ZplSpacer(flex: 1),

          // Section 4: Bottom Split Box
          ZplStack(
            children: [
              ZplGraphicBox(width: 760, height: 220, thickness: 3),
              ZplPadding(
                padding: ZplEdgeInsets.only(left: 380),
                child: ZplGraphicBox(width: 3, height: 220, thickness: 3),
              ),
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
              ZplPadding(
                padding: ZplEdgeInsets.only(left: 450, top: 30),
                child: ZplText('CA', font: ZplFont.helvetica(size: 195)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _generateZpl() {
    final width = int.tryParse(_widthController.text) ?? 800;
    final height = int.tryParse(_heightController.text) ?? 600;

    final root = _buildRoot();
    setState(() {
      _lastRoot = root;
      _zplCode = ZplKit.build(root, labelSize: ZplLabelSize(width, height));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ZPL Kit Example'),
          elevation: 2,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.code), text: 'ZPL Code'),
              Tab(icon: Icon(Icons.preview), text: 'Native Preview'),
              Tab(icon: Icon(Icons.cloud_done), text: 'Labelary Preview'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _buildZplView(), 
                  _buildPreviewView(),
                  _buildLabelaryPreviewView(),
                ],
              ),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildZplView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: SelectableText(
            _zplCode,
            style: const TextStyle(
              fontFamily: 'Courier',
              color: Colors.greenAccent,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewView() {
    if (_lastRoot == null) {
      return const Center(child: Text('Generate ZPL to see Preview'));
    }

    return Container(
      color: Colors.grey[300], // "Desk" surface
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Center(
          child: ZplPreview(root: _lastRoot!, labelSize: _selectedSize),
        ),
      ),
    );
  }

  Widget _buildLabelaryPreviewView() {
    if (_lastRoot == null) {
      return const Center(child: Text('Generate ZPL to see Labelary Preview'));
    }

    return Container(
      color: Colors.grey[300], // "Desk" surface
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Center(
          child: ZplLabelaryPreview(
            root: _lastRoot!, 
            labelSize: _selectedSize,
            dpmm: 8, // Assuming 203 DPI since 800 dots / 4 inches = 200 (~203)
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<ZplLabelSize>(
                  initialValue: _selectedSize,
                  decoration: const InputDecoration(
                    labelText: 'Label Size',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  items: ZplLabelSize.commonSizes.map((size) {
                    return DropdownMenuItem(
                      value: size,
                      child: Text(
                        size.name,
                        style: const TextStyle(fontSize: 12),
                      ),
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
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _ipController,
                  decoration: const InputDecoration(
                    labelText: 'Printer IP',
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _generateZpl,
                  icon: const Icon(Icons.sync),
                  label: const Text('Refresh'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _isPrinting ? null : _printToPrinter,
                  icon: _isPrinting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.print),
                  label: const Text('SEND TO PRINTER'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
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
