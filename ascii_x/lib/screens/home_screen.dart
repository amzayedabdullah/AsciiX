import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/ascii_converter.dart';
import 'ascii_output_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? imageFile;
  bool loading = false;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  Future<void> generateAscii() async {
    if (imageFile == null) return;
    setState(() => loading = true);

    final ascii = await AsciiConverter.convertImageToAscii(
      imageFile!,
      width: 100,
    );

    setState(() => loading = false);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AsciiOutputScreen(asciiText: ascii)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AsciiX")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            imageFile == null
                ? Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[800],
                    alignment: Alignment.center,
                    child: const Text("No Image Selected"),
                  )
                : Image.file(imageFile!, height: 200),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Pick Image"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loading ? null : generateAscii,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Convert to ASCII"),
            ),
          ],
        ),
      ),
    );
  }
}
