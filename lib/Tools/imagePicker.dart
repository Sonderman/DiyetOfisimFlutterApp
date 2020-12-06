import 'dart:io';
import 'dart:typed_data';
import 'package:diyet_ofisim/Tools/ImageEditor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List> getImageFromCamera(BuildContext context) async {
  final picker = ImagePicker();
  final image = await picker.getImage(source: ImageSource.camera);
  if (image != null)
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ImageEditorPage(
                  image: File(image.path),
                  forCreateEvent: false,
                ))).then((value) => value);
  else
    return null;
}

// ANCHOR galeriden foto almaya yarar
Future<Uint8List> getImageFromGallery(BuildContext context) async {
  final picker = ImagePicker();
  final image = await picker.getImage(source: ImageSource.gallery);
  if (image != null)
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ImageEditorPage(
                  image: File(image.path),
                  forCreateEvent: false,
                ))).then((value) => value);
  else
    return null;
}
