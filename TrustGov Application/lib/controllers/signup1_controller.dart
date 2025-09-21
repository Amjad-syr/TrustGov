import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUp1Controller extends GetxController {
  var idImages = <File>[].obs;
  var faceImage = Rx<File?>(null);
  var isRecording = false.obs;
  var recordedAudioPath = "".obs;

  Future<void> uploadID() async {
    if (idImages.length >= 2) return;
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) idImages.add(File(pickedFile.path));
  }

  void removeIDImage(int index) {
    idImages.removeAt(index);
  }

  Future<void> uploadFacePhoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) faceImage.value = File(pickedFile.path);
  }

  Future<void> takeFacePhoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) faceImage.value = File(pickedFile.path);
  }
}
