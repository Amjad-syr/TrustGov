import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../BackendUrl.dart';
import 'AuthController.dart';

class JoinContractLinkController extends GetxController {
  var linkController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  void verifyLink() async {
    final link = linkController.text.trim();

    if (link.isEmpty) {
      Get.snackbar("Error", "Please enter a valid contract link.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }

    final url = Uri.parse('${GlobalConfig.backendUrl}/user/rooms/join');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
        body: jsonEncode({'code': link}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        Get.toNamed('/finalize-contract', arguments: {
          'room': data['room'],
          'contract': data['contract'],
          'property': data['property'],
          'room_code': data['room']['code'],
        });
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          error['message'] ?? "Failed to join the contract.",
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
