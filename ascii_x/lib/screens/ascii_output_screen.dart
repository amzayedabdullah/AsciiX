import 'package:flutter/rendering.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AsciiOutputScreen extends StatefulWidget {
  final String asciiText;
  const AsciiOutputScreen({super.key, required this.asciiText});

  @override
  State<AsciiOutputScreen> createState() => _AsciiOutputScreenState();
}

class _AsciiOutputScreenState extends State<AsciiOutputScreen> {
  final GlobalKey _globalKey = GlobalKey();
  bool saving = false;

  Future<void> saveAndShare() async {
    try {
      setState(() => saving = true);

      // Request permission for Android 10 and below
      await Permission.storage.request();

      final boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception("Image capture failed.");
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File(
        "${dir.path}/ascii_${DateTime.now().millisecondsSinceEpoch}.png",
      );

      await file.writeAsBytes(pngBytes);

      setState(() => saving = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Saved & ready to share!")));

      await Share.shareXFiles([XFile(file.path)], text: "Check my ASCII art!");
    } catch (e) {
      setState(() => saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ASCII Output"),
        actions: [
          IconButton(
            onPressed: saving ? null : saveAndShare,
            icon: saving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.save_alt),
          ),
        ],
      ),
      body: Center(
        child: RepaintBoundary(
          key: _globalKey,
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              widget.asciiText,
              style: const TextStyle(
                fontFamily: "monospace",
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
