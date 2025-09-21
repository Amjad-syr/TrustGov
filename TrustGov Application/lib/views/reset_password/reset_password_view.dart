import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text_field.dart';
import '../../controllers/reset_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Reset password"),
      backgroundColor: const Color(0xFF35444F),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            const Text(
              "Reset Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please enter your National ID to reset your password",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              label: "National Number",
              controller: controller.nationalIDController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.resetPassword(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3DA09D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        "Reset password",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
