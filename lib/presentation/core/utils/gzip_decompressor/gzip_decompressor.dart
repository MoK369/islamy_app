import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract class GzipDecompressor {
  static Future<String> loadCompressedInBackground(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final compressed = byteData.buffer.asUint8List();
    return compute(decompressGz, compressed);
  }

  static String decompressGz(Uint8List compressed) {
    final decompressed = const GZipDecoder().decodeBytes(compressed);
    return utf8.decode(decompressed);
  }
}
