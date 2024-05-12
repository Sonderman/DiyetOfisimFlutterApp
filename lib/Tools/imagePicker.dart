import 'dart:io';
import 'package:diyet_ofisim/Tools/ImageEditor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(
    {required BuildContext context, required ImageSource source}) async {
  final ImagePicker picker = ImagePicker();

  final XFile? image = await picker.pickImage(source: source);

  if (image != null && context.mounted) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ImageEditorPage(
                  image: File(image.path),
                  forCreateEvent: false,
                ))).then((value) => value);
  } else {
    return null;
  }
}
