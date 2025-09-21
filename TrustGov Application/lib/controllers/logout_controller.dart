import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../BackendUrl.dart';
import 'AuthController.dart';

class LogoutController extends GetxController {
  Future<void> logout() async {
    final AuthController authController = Get.find<AuthController>();
    final token = authController.token;

    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "No token found. Please log in first.");
      return;
    }

    const url = '${GlobalConfig.backendUrl}/user/logout';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        await authController.removeToken();
        Get.snackbar("Success", "You have been logged out.");
        Get.offAllNamed('/login');
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar("Error", errorData['message'] ?? "Logout failed.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }
}
