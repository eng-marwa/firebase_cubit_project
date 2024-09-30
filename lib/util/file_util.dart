import 'package:image_picker/image_picker.dart';

class FileUtil {
  FileUtil._();

  static Future<String> pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      return xFile.path;
    } else {
      throw Exception('No image selected');
    }
  }
}
