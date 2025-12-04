import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';

class AsciiConverter {
  static const String asciiChars = "@%#*+=-:. ";

  static Future<String> convertImageToAscii(
    File file, {
    int width = 100,
  }) async {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final img = frame.image;

    final ratio = img.height / img.width;
    final height = (width * ratio).toInt();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint();

    canvas.drawImageRect(
      img,
      ui.Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
      ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      paint,
    );

    final picture = recorder.endRecording();
    final resized = await picture.toImage(width, height);

    final byteData = await resized.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );

    if (byteData == null) return "";

    final pixels = byteData.buffer.asUint8List();
    final buffer = StringBuffer();

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final idx = (y * width + x) * 4;
        final r = pixels[idx];
        final g = pixels[idx + 1];
        final b = pixels[idx + 2];

        final gray = (0.299 * r + 0.587 * g + 0.114 * b).round();
        final charIndex = (gray / 255 * (asciiChars.length - 1)).round();

        buffer.write(asciiChars[charIndex]);
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}
