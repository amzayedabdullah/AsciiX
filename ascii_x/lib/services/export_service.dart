import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as IMG;
import 'package:gallery_saver_plus/gallery_saver_plus.dart';

class ExportService {
  static Future<Uint8List> exportAsciiToPng(String ascii, bool dark) async {
    final lines = ascii.split('\n');
    const fontSize = 10;

    final width = lines.fold<int>(0, (p, e) => e.length > p ? e.length : p) * 7;
    final height = lines.length * 14;

    final img = IMG.Image(width: width, height: height);
    IMG.fill(img, dark ? IMG.getColor(0, 0, 0) : IMG.getColor(255, 255, 255));

    int y = 0;
    for (final line in lines) {
      IMG.drawString(
        img,
        IMG.arial_24,
        0,
        y,
        line,
        color: dark ? IMG.getColor(255, 128, 0) : IMG.getColor(0, 0, 0),
      );
      y += 14;
    }

    return Uint8List.fromList(IMG.encodePng(img));
  }

  static Future<void> saveToGallery(Uint8List pngBytes) async {
    await GallerySaver.saveImageBytes(pngBytes, albumName: "ASCII Art");
  }
}
