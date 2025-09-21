// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../BackendUrl.dart';
import 'AuthController.dart';

class FillContractInfoController extends GetxController {
  var contractType = "Buy Contract".obs;
  var propertyId = "".obs;
  var propertyLocation = "".obs;
  var description = "".obs;
  var isLoading = false.obs;

  final List<String> contractTypes = ["Buy Contract", "Rent Contract"];

  final TextEditingController propertyIdController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController sellerAddressController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  Future<void> fetchPropertyDetails(String id) async {
    if (id.trim().isEmpty) {
      Get.snackbar("Error", "Property ID cannot be empty.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final url =
          Uri.parse('${GlobalConfig.backendUrl}/user/properties/getall');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'] as List;
        final property = responseData.firstWhere(
            (prop) => prop['property_id'].toString() == id,
            orElse: () => null);

        if (property != null) {
          propertyLocation.value = property['property_location'] ?? "N/A";
          description.value = property['description'] ?? "N/A";
        } else {
          clearFields();
          Get.snackbar("Error", "Property not found. Please enter a valid ID.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch property details.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRentRoom() async {
    if (propertyIdController.text.trim().isEmpty) {
      Get.snackbar("Validation Error", "Please enter a valid Property ID.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }

    final body = {
      'room_type': 'rent',
      'property_id': propertyIdController.text.trim(),
      'seller_address': sellerAddressController.text.trim(),
    };

    await _createRoom(body);
  }

  Future<void> createBuyRoom() async {
    if (propertyIdController.text.trim().isEmpty) {
      Get.snackbar("Validation Error", "Please enter a valid Property ID.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }

    final body = {
      'room_type': 'buy',
      'property_id': propertyIdController.text.trim(),
      'total_amount': totalAmountController.text.trim(),
      'paid_amount': paidAmountController.text.trim(),
      'notes': notesController.text.trim(),
    };

    await _createRoom(body);
  }

  Future<void> _createRoom(Map<String, dynamic> body) async {
    isLoading.value = true;

    try {
      final url = Uri.parse('${GlobalConfig.backendUrl}/user/rooms/create');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
        body: jsonEncode(body),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        Get.snackbar("Success", "Room created successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        Get.toNamed('/send-contract-link',
            arguments: {'room_code': data['code']});
      } else {
        Get.snackbar("Error", "Failed to create room.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    propertyLocation.value = "";
    description.value = "";
    totalAmountController.clear();
    paidAmountController.clear();
    notesController.clear();
    sellerAddressController.clear();
  }

  @override
  void onClose() {
    propertyIdController.dispose();
    totalAmountController.dispose();
    paidAmountController.dispose();
    notesController.dispose();
    sellerAddressController.dispose();
    super.onClose();
  }
}
