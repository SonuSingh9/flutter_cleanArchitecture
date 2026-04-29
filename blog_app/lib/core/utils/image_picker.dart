import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    debugPrint('pickImage: opening gallery...');
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    debugPrint('pickImage: xFile = $xFile');
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  } catch (e, st) {
    debugPrint('pickImage error: $e\n$st');
    return null;
  }
}