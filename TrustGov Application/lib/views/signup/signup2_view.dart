import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/signup2_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text_field.dart';

class SignUp2View extends StatelessWidget {
  final SignUp2Controller controller = Get.put(SignUp2Controller());

  SignUp2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Check Your Info"),
      backgroundColor: const Color(0xFF35444F),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(() => CustomTextField(
                  label: "National ID",
                  hintText: controller.nationalId.value,
                  isReadOnly: true,
                )),
            Obx(() => CustomTextField(
                  label: "First Name",
                  hintText: controller.firstName.value,
                  isReadOnly: true,
                )),
            Obx(() => CustomTextField(
                  label: "Last Name",
                  hintText: controller.lastName.value,
                  isReadOnly: true,
                )),
            Obx(() => CustomTextField(
                  label: "Father's Name",
                  hintText: controller.fatherName.value,
                  isReadOnly: true,
                )),
            Obx(() => CustomTextField(
                  label: "Mother's Full Name",
                  hintText: controller.motherFullName.value,
                  isReadOnly: true,
                )),
            Obx(() => CustomTextField(
                  label: "Gender",
                  hintText: controller.gender.value,
                  isReadOnly: true,
                )),
            Obx(() => CustomTextField(
                  label: "Birth Date",
                  hintText: controller.birthDate.value,
                  isReadOnly: true,
                )),
            Obx(() => CustomTextField(
                  label: "ID Number",
                  hintText: controller.idNumber.value,
                  isReadOnly: true,
                )),
            Obx(() => CustomTextField(
                  label: "Special Features",
                  hintText: controller.specialFeatures.value.isEmpty
                      ? "None"
                      : controller.specialFeatures.value,
                  isReadOnly: true,
                )),
            const SizedBox(height: 20),
            CustomTextField(
              label: "New Password",
              isPassword: true,
              controller: controller.passwordController,
            ),
            CustomTextField(
              label: "Confirm Password",
              isPassword: true,
              controller: controller.confirmPasswordController,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _validateAndProceed(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3DA09D),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Sign up",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndProceed(BuildContext context) {
    if (controller.validatePasswords()) {
      _showConfirmationPopup(context);
    } else {}
  }

  void _showConfirmationPopup(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: const Text(
            "Are you sure that all the previous information is correct?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await controller.saveUser();
              Get.offNamed('/account-created');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3DA09D)),
            child:
                const Text("Continue", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
