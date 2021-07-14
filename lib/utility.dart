import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'dart:convert';

class Utility {
  static String base64(Uint8List data) {
    return base64Encode(data);
  }

  static Image baseToImg(String data) {
    return Image.memory(
      base64Decode(data),
      fit: BoxFit.fill,
    );
  }
}
