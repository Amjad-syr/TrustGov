import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../BackendUrl.dart';
import 'AuthController.dart';

class SendContractLinkController extends GetxController {
  var contractLink = ''.obs;
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    contractLink.value = Get.arguments?['room_code'] ?? "No link available.";
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: contractLink.value));
    Get.snackbar("Copied", "Contract link copied to clipboard.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white);
  }

  void navigateToFinalizeContract() async {
    final url = Uri.parse('${GlobalConfig.backendUrl}/user/rooms/join');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
        body: jsonEncode({'code': contractLink.value}),
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
          error['message'] ?? "Failed to proceed.",
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
