import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const String google_api_key = "AIzaSyCFAKHpuOJ-EcH71WOhb11Bg0I8OQjrOhY";

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}

Future<Uint8List?> pickImage() async {
  FilePickerResult? pickedImage =
      await FilePicker.platform.pickFiles(type: FileType.image);
  if (pickedImage != null) {
    //web version
    if (kIsWeb) {
      return pickedImage.files.single.bytes;
    }
    //mobile version
    return await File(pickedImage.files.single.path!).readAsBytes();
  }
  return null;
}
