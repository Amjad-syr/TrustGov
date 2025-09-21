import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class SignUp2Controller extends GetxController {
  var nationalId = "01040118243".obs;
  var firstName = "Wasem".obs;
  var lastName = "Alsirawan".obs;
  var fatherName = "Youssef".obs;
  var motherFullName = "Huda".obs;
  var gender = "Male".obs;
  var birthDate = "1980-04-10".obs;
  var idNumber = "00095638".obs;
  var specialFeatures = "".obs;

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  User get user => User(
        nationalId: nationalId.value,
        firstName: firstName.value,
        lastName: lastName.value,
        fatherName: fatherName.value,
        motherFullName: motherFullName.value,
        gender: gender.value,
        birthDate: DateTime.parse(birthDate.value),
        idNumber: idNumber.value,
        specialFeatures: specialFeatures.value,
      );

  bool validatePasswords() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Validation Error", "Password fields cannot be empty.");
      return false;
    }

    if (!isComplexPassword(password)) {
      Get.snackbar("Validation Error",
          "Password must be at least 8 characters long, include uppercase and lowercase letters, numbers, and special characters.");
      return false;
    }

    if (password != confirmPassword) {
      Get.snackbar("Validation Error", "Passwords do not match.");
      return false;
    }

    return true;
  }

  bool isComplexPassword(String password) {
    final regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$');
    return regex.hasMatch(password);
  }

  Future<void> saveUser() async {}

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
