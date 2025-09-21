import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../BackendUrl.dart';
import 'AuthController.dart';

class VerifyIdentityController extends GetxController {
  var faceImage = Rx<File?>(null);
  var isRecording = false.obs;
  var isSubmitting = false.obs;
  var recordedAudioPath = "".obs;

  final AuthController authController = Get.find<AuthController>();

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

  Future<void> voteForCandidate() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;

    final candidate = Get.arguments?['candidate'];
    final election = Get.arguments?['election'];

    if (candidate == null || election == null) {
      Get.snackbar("Error", "Invalid election or candidate data.");
      isSubmitting.value = false;
      return;
    }

    final token = authController.token;
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "No token found. Please log in first.");
      isSubmitting.value = false;
      return;
    }

    final url = Uri.parse('${GlobalConfig.backendUrl}/user/elections/vote');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'election_id': election['id'],
          'candidate_id': candidate['national_id'],
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Vote submitted successfully.");
        Get.offAllNamed('/voted-successfully', arguments: {
          "candidate": candidate['name'],
        });
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          errorData['message'] ?? "Failed to submit vote.",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isSubmitting.value = false;
    }
  }
}
