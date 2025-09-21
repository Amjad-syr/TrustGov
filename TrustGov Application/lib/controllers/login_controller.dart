// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../BackendUrl.dart';
import 'AuthController.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login(String nationalNumber, String password) async {
    if (nationalNumber.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    final url = Uri.parse('${GlobalConfig.backendUrl}/user/login');
    final headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({'national_id': nationalNumber, 'password': password});

    try {
      final response = await http.post(url, headers: headers, body: body);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['data']?['access_token'];

        if (accessToken == null || accessToken.isEmpty) {
          throw Exception('Token is missing from the response');
        }

        final authController = Get.find<AuthController>();
        await authController.saveToken(accessToken);
        print("Token Saved: $accessToken");
        Get.offNamed('/home');
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          errorData['message'] ?? 'Login failed',
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
    } finally {
      isLoading.value = false;
    }
  }
}
