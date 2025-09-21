// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../BackendUrl.dart';
import '../models/user_model.dart';
import 'AuthController.dart';
import 'package:flutter/material.dart';

class PersonalInfoController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final nationalNumber = "".obs;
  final fullName = "".obs;
  final fatherName = "".obs;
  final motherName = "".obs;
  final gender = "".obs;
  final birthDate = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      final url = Uri.parse('${GlobalConfig.backendUrl}/user/profile');
      var response = await http.get(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];

        if (data != null) {
          final user = User.fromJson(data);

          nationalNumber.value = user.nationalId.toString();
          fullName.value = "${user.firstName} ${user.lastName}";
          fatherName.value = user.fatherName;
          motherName.value = user.motherFullName;
          gender.value = user.gender;
          birthDate.value = user.birthDate.toLocal().toString().split(' ')[0];
        } else {
          Get.snackbar(
            "Error",
            "No user data found in the response.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          errorData['message'] ?? "Failed to load user info.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
