// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../BackendUrl.dart';
import 'AuthController.dart';

class FinalizeContractController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  var buyerConfirmed = false.obs;
  var sellerConfirmed = false.obs;

  var roomCode = "".obs;

  var contractInformation = <String, String>{}.obs;

  Timer? _statusCheckTimer;

  @override
  void onInit() {
    super.onInit();
    final data = Get.arguments;
    if (data != null) {
      roomCode.value = data['room_code'] ?? "N/A";
      _initializeContractData(data);
      _startStatusCheck();
    }
  }

  void _initializeContractData(Map<String, dynamic> data) {
    final room = data['room'] ?? {};
    final contract = data['contract'] ?? {};
    final property = data['property'] ?? {};

    contractInformation.value = {
      "Contract Type": room['room_type'] ?? "N/A",
      "Buyer ID": contract['buyer_id']?.toString() ?? "N/A",
      "Seller ID": contract['seller_id']?.toString() ?? "N/A",
      "Property ID": contract['property_id']?.toString() ?? "N/A",
      "Property Location": property['property_location'] ?? "N/A",
      "Description": property['description'] ?? "N/A",
      if (room['room_type'] == "rent")
        "Seller Address": contract['seller_address'] ?? "N/A",
      if (room['room_type'] == "buy")
        "Total Amount": contract['total_amount'].toString(),
      if (room['room_type'] == "buy")
        "Paid Amount": contract['paid_amount'].toString(),
      if (room['room_type'] == "buy") "Notes": contract['notes'] ?? "N/A",
      "Date": contract['date'] ?? "N/A",
    };
  }

  void _startStatusCheck() {
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await _checkRoomStatus();
    });
  }

  Future<void> _checkRoomStatus() async {
    final url = Uri.parse(
        '${GlobalConfig.backendUrl}/user/rooms/status/${roomCode.value}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        buyerConfirmed.value = data['joiner_confirmed'] == 1;
        contractInformation["Buyer ID"] =
            data['joiner_national_id']?.toString() ?? "N/A";
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to check room status: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  Future<void> confirmAsSeller() async {
    final url = Uri.parse(
        '${GlobalConfig.backendUrl}/user/rooms/confirm/${roomCode.value}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        sellerConfirmed.value = true;
        await _endRoom();
      } else {
        Get.snackbar("Error", "Failed to confirm room.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  Future<void> _endRoom() async {
    final url = Uri.parse('${GlobalConfig.backendUrl}/user/rooms/end');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
        body: jsonEncode({'code': roomCode.value}),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        Get.offAllNamed('/contract-completed');
      } else {
        Get.snackbar("Error", "Failed to end room.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  void copyLinkToClipboard() {
    Clipboard.setData(ClipboardData(text: roomCode.value));
    Get.snackbar("Copied", "Room code copied to clipboard.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white);
  }

  @override
  void onClose() {
    _statusCheckTimer?.cancel();
    super.onClose();
  }
}
