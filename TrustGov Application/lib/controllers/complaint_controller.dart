// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:trustgov/routes/app_routes.dart';
import '../BackendUrl.dart';
import 'AuthController.dart';
import '../models/complaint_model.dart';

class ComplaintController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  var complaints = <ComplaintModel>[].obs;

  final descController = TextEditingController();
  final locationController = TextEditingController();
  var picture1 = Rx<File?>(null);
  var picture2 = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    final url = Uri.parse('${GlobalConfig.backendUrl}/user/complaints/pending');
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
        final data = jsonDecode(response.body)['data'];
        complaints.value = data.map<ComplaintModel>((item) {
          item['picture_path1'] = item['picture_path1']
              .replaceFirst('http://127.0.0.1', GlobalConfig.backendUrl);
          item['picture_path2'] = item['picture_path2']
              .replaceFirst('http://127.0.0.1', GlobalConfig.backendUrl);
          return ComplaintModel.fromJson(item);
        }).toList();
      } else {
        Get.snackbar("Error", "Failed to fetch complaints.",
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

  Future<void> voteComplaint(int complaintId, int type) async {
    final url = Uri.parse('${GlobalConfig.backendUrl}/user/complaints/vote');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
        body: jsonEncode({'complaint_id': complaintId, 'type': type}),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final complaint = complaints.firstWhere((c) => c.id == complaintId);
        complaint.isUpvoted.value = type == 1;
        complaint.isDownvoted.value = type == 0;
      } else {
        Get.snackbar("Error", "Failed to vote.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  Future<void> pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (index == 1) {
        picture1.value = File(pickedFile.path);
      } else {
        picture2.value = File(pickedFile.path);
      }
    }
  }

  Future<void> createComplaint() async {
    if (descController.text.isEmpty ||
        locationController.text.isEmpty ||
        picture1.value == null ||
        picture2.value == null) {
      Get.snackbar("Error", "All fields are required.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      return;
    }

    final url = Uri.parse('${GlobalConfig.backendUrl}/user/complaints/create');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer ${authController.token}'
      ..fields['desc'] = descController.text
      ..fields['location'] = locationController.text
      ..files.add(
          await http.MultipartFile.fromPath('picture1', picture1.value!.path))
      ..files.add(
          await http.MultipartFile.fromPath('picture2', picture2.value!.path));

    try {
      final response = await request.send();
      print("Response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Complaint created successfully.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        fetchComplaints();
        Get.offAllNamed(AppRoutes.settings);
        Get.back();
      } else {
        Get.snackbar("Error", "Failed to create complaint.",
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

  @override
  void onClose() {
    descController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
