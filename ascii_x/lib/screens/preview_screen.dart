import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/export_service.dart';

class PreviewScreen extends StatelessWidget {
  final String asciiText;
  final bool isDark;
  const PreviewScreen({
    super.key,
    required this.asciiText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Export Preview")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            asciiText,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.save_alt_rounded),
        label: const Text("Save as PNG"),
        onPressed: () async {
          Uint8List png = await ExportService.exportAsciiToPng(
            asciiText,
            isDark,
          );
          ExportService.saveToGallery(png);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Saved to gallery!")));
        },
      ),
    );
  }
}
