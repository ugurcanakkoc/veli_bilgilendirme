import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

void CameraService() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  {
    final File file = await takePicture();
    print(file.path);

    final String url = await uploadToFirebase(file);
    print(url);
  }
}

Future<File> takePicture() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  return File(pickedFile!.path);
}

Future<String> uploadToFirebase(File file) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Reference ref =
      storage.ref().child('images/${DateTime.now().toString()}.jpg');

  final UploadTask uploadTask = ref.putFile(file);
  final TaskSnapshot downloadUrl = (await uploadTask);
  final String url = await downloadUrl.ref.getDownloadURL();

  return url;
}
