import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<Uint8List?> pickImageBytes() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      return file.bytes;
    } else {
      // Usuario canceló la selección de archivos
      return null;
    }
  }
}
