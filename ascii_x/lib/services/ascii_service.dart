import 'dart:typed_data';
import 'package:image/image.dart' as IMG;

class AsciiService {
  static const String lightChars = " .:-=+*#%@";
  static const String darkChars = "@%#*+=-:. ";

  static Future<String> imageToAscii(Uint8List bytes, bool darkMode) async {
    IMG.Image? img = IMG.decodeImage(bytes);
    if (img == null) return "Image decode error";

    img = IMG.copyResize(img, width: 120);

    final buffer = StringBuffer();
    final chars = darkMode ? darkChars : lightChars;

    for (int y = 0; y < img.height; y += 2) {
      for (int x = 0; x < img.width; x++) {
        final pixel = img.getPixel(x, y);
        int r = IMG.getRed(pixel);
        int g = IMG.getGreen(pixel);
        int b = IMG.getBlue(pixel);
        double brightness = (r + g + b) / 3;
        int index = (brightness / 255 * (chars.length - 1)).round();
        buffer.write(chars[index]);
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
}
