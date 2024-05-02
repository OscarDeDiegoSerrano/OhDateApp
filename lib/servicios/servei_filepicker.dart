import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ohdate_app/auth/portal_auth.dart';

class FilePickerWidget extends StatefulWidget {
  @override
  _FilePickerWidgetState createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  File? _selectedImageFileApp;
  Uint8List? _selectedImageBytesWeb;
  bool _imageReadyToUpload = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (!kIsWeb) {
        File selectedFile = File(image.path);

        setState(() {
          _selectedImageFileApp = selectedFile;
          _imageReadyToUpload = true;
        });
      } else {
        Uint8List bytes = await image.readAsBytes();

        setState(() {
          _selectedImageBytesWeb = bytes;
          _imageReadyToUpload = true;
        });
      }
    }
  }

  Future<bool> uploadImageForUser() async {
    String userId = ServeiAuth().getUsuariActual()!.uid;

    if (_selectedImageFileApp != null) {
      try {
        Reference ref = FirebaseStorage.instance.ref().child("$userId/avatar/$userId");
        await ref.putFile(_selectedImageFileApp!);
        return true;
      } catch (e) {
        return false;
      }
    }

    if (_selectedImageBytesWeb != null) {
      try {
        Reference ref = FirebaseStorage.instance.ref().child("$userId/avatar/$userId");
        await ref.putData(_selectedImageBytesWeb!);
        return true;
      } catch (e) {
        return false;
      }
    }

    return false;
  }

  Future<String> getProfileImage() async {
    final String userId = ServeiAuth().getUsuariActual()!.uid;
    final Reference ref = FirebaseStorage.instance.ref().child("$userId/avatar/$userId");

    try {
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return ''; // Devuelve una cadena vacía si hay un error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Seleccionar imagen'),
        ),
        _imageReadyToUpload ? ElevatedButton(
          onPressed: () async {
            bool success = await uploadImageForUser();
            if (success) {
              // Manejar éxito
            } else {
              // Manejar fallo
            }
          },
          child: Text('Subir imagen'),
        ) : Container(),
        FutureBuilder(
          future: getProfileImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError) {
              return Icon(Icons.person);
            }

            if (snapshot.data != null && snapshot.data != '') {
              return Image.network(
                snapshot.data!,
                errorBuilder: (context, error, stackTrace) {
                  return Text("Error al cargar la imagen: $error");
                },
              );
            } else {
              return Icon(Icons.person); // O cualquier otra cosa si no hay imagen
            }
          },
        ),
      ],
    );
  }
}
