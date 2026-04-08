import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../zpl_kit.dart';

/// A widget that renders a visual preview of a [ZplComponent] tree
/// by calling the external Labelary.com API and displaying the returned image.
///
/// This provides a 100% accurate, true-to-printer preview, but requires an active
/// internet connection.
class ZplLabelaryPreview extends StatefulWidget {
  /// The root component of the label to preview.
  final ZplComponent root;

  /// The physical size of the label (in dots).
  final ZplLabelSize labelSize;

  /// The printer density in dots per millimeter (dpmm).
  /// Common values: 8 (203dpi), 12 (300dpi), 24 (600dpi). Default is 8.
  final int dpmm;

  /// The color of the label background while loading.
  final Color backgroundColor;

  /// Creates a new `ZplLabelaryPreview`.
  const ZplLabelaryPreview({
    super.key,
    required this.root,
    required this.labelSize,
    this.dpmm = 8,
    this.backgroundColor = Colors.white,
  });

  @override
  State<ZplLabelaryPreview> createState() => _ZplLabelaryPreviewState();
}

class _ZplLabelaryPreviewState extends State<ZplLabelaryPreview> {
  Uint8List? _imageData;
  String? _error;
  bool _isLoading = false;
  String _lastBuiltZpl = '';

  @override
  void initState() {
    super.initState();
    _fetchLabelaryImage();
  }

  @override
  void didUpdateWidget(covariant ZplLabelaryPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only re-fetch if the generated ZPL string or dimensions actually change
    // This prevents unnecessary network calls during meaningless rebuilds
    final newZpl = ZplKit.build(widget.root, labelSize: widget.labelSize);
    final widthChanged = oldWidget.labelSize.width != widget.labelSize.width;
    final heightChanged = oldWidget.labelSize.height != widget.labelSize.height;
    final dpmmChanged = oldWidget.dpmm != widget.dpmm;

    if (newZpl != _lastBuiltZpl ||
        widthChanged ||
        heightChanged ||
        dpmmChanged) {
      _fetchLabelaryImage();
    }
  }

  Future<void> _fetchLabelaryImage() async {
    // Generate the ZPL code first
    final zplCode = ZplKit.build(widget.root, labelSize: widget.labelSize);

    setState(() {
      _isLoading = true;
      _error = null;
      _lastBuiltZpl = zplCode;
    });

    try {
      // Calculate inches based on dots and dpmm
      // Example: 800 dots / (8 dots/mm * 25.4 mm/inch) = 3.937 inches
      final double dotsPerInch = widget.dpmm * 25.4;
      final double widthInches = widget.labelSize.width / dotsPerInch;
      final double heightInches = widget.labelSize.height / dotsPerInch;

      final imageData = await LabelaryService.renderZplToPng(
        zpl: zplCode,
        widthInches: widthInches,
        heightInches: heightInches,
        dpmm: widget.dpmm,
      );

      if (mounted) {
        setState(() {
          _imageData = imageData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the scale based on the available width to maintain aspect ratio
        final double screenWidthSize = constraints.maxWidth;
        final double logicalHeight =
            (screenWidthSize / widget.labelSize.width) *
                widget.labelSize.height;

        return Center(
          child: Container(
            width: screenWidthSize,
            height: logicalHeight,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: _buildContent(),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (_isLoading && _imageData == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.teal),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Labelary Preview Failed',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.red),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchLabelaryImage,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_imageData != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(
            _imageData!,
            fit: BoxFit.fill,
          ),
          if (_isLoading)
            Container(
              color: Colors.white.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.teal),
              ),
            ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
