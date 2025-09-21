import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/verify_identity_controller.dart';
import '../../widgets/custom_appbar.dart';

class VerifyIdentityView extends StatelessWidget {
  final VerifyIdentityController controller =
      Get.put(VerifyIdentityController());

  VerifyIdentityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Verify Identity"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            const SizedBox(height: 20),
            _buildFacePhotoField(),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_validateFields()) {
                  controller.voteForCandidate();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3DA09D),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Obx(() => controller.isSubmitting.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Verify and Vote",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacePhotoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text(
            "Take a photo of your face",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          trailing: Wrap(
            spacing: 10,
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: controller.takeFacePhoto,
              ),
              IconButton(
                icon: const Icon(Icons.photo_library, color: Colors.white),
                onPressed: controller.uploadFacePhoto,
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.faceImage.value != null) {
            return Stack(
              children: [
                Container(
                  width: 400,
                  height: 200,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(controller.faceImage.value!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => controller.faceImage.value = null,
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        }),
      ],
    );
  }

  bool _validateFields() {
    if (controller.faceImage.value == null) {
      Get.snackbar("Validation Error", "Please upload or take a face photo.");
      return false;
    }
    return true;
  }
}
