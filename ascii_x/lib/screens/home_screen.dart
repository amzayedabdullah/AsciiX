import 'package:flutter/material.dart';
import '../services/ascii_service.dart';
import '../widgets/theme_switcher.dart';
import '../widgets/image_picker_button.dart';
import 'preview_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDark;
  const HomeScreen({super.key, required this.onThemeToggle, required this.isDark});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String asciiOutput = '';
  Uint8List? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ASCII Converter"),
        actions: [ThemeSwitcher(isDark: widget.isDark, onToggle: widget.onThemeToggle)],
      ),
      body: Column(
        children: [
          ImagePickerButton(onImageSelected: (img) async {
            selectedImage = img;
            asciiOutput = await AsciiService.imageToAscii(img, widget.isDark);
            setState(() {});
          }),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Text(asciiOutput, style: const TextStyle(fontFamily: 'monospace')),
            ),
          ),
        ],
      ),
      floatingActionButton: selectedImage == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PreviewScreen(asciiText: asciiOutput, isDark: widget.isDark),
                  ),
                );
              },
              label: const Text("Export"),
              icon: const Icon(Icons.download_rounded),
            ),
    );
  }
}
