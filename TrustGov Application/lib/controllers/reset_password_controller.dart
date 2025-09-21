import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController nationalIDController = TextEditingController();

  var isLoading = false.obs;

  bool validateNationalID(String nationalID) {
    final regex = RegExp(r'^\d{9}$');
    return regex.hasMatch(nationalID);
  }

  void resetPassword() async {
    String nationalID = nationalIDController.text.trim();

    if (nationalID.isEmpty) {
      Get.snackbar(
        "Error",
        "National ID cannot be empty.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (!validateNationalID(nationalID)) {
      Get.snackbar(
        "Error",
        "Invalid National ID format.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        "Success",
        "Reset link has been sent to your phone number.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred while sending the reset link.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nationalIDController.dispose();
    super.onClose();
  }
}
