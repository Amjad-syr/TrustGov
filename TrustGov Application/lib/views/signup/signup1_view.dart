import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/signup1_controller.dart';
import '../../widgets/custom_appbar.dart';

class SignUp1View extends StatelessWidget {
  final controller = Get.put(SignUp1Controller());

  SignUp1View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Sign Up"),
      backgroundColor: const Color(0xFF35444F),
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
            _buildIDUploadField(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_validateFields()) {
                  Get.toNamed('/signup2');
                } else {
                  Get.snackbar("Validation Error",
                      "Please ensure all fields are completed.");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3DA09D),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                "Next",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIDUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text(
            "Upload Your ID (The both sides)",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          trailing: const Icon(Icons.add_circle_outline, color: Colors.white),
          onTap: controller.uploadID,
        ),
        Obx(() {
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(controller.idImages.length, (index) {
              return Stack(
                children: [
                  Container(
                    width: 400,
                    height: 200,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(controller.idImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => controller.removeIDImage(index),
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }),
          );
        }),
      ],
    );
  }

  bool _validateFields() {
    if (controller.idImages.length != 2) {
      Get.snackbar("Validation Error", "Please upload both sides of your ID.");
      return false;
    }
    return true;
  }
}
