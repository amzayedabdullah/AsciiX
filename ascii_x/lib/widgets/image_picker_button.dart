import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatelessWidget {
  final Function(Uint8List) onImageSelected;
  const ImagePickerButton({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () async {
          final picker = ImagePicker();
          final img = await picker.pickImage(source: ImageSource.gallery);
          if (img != null) onImageSelected(await img.readAsBytes());
        },
        child: const Text("Pick Image"),
      ),
    );
  }
}
