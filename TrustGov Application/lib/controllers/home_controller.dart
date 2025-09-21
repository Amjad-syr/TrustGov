// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../BackendUrl.dart';
import 'notification_controller.dart';
import 'AuthController.dart';
import '../models/election_model.dart';

class HomeController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  Rx<Duration> remainingTime = Duration.zero.obs;
  RxString electionName = "Election".obs;
  late Timer timer;

  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void onInit() {
    super.onInit();
    fetchLatestElection();
    ever(notificationController.notifications, (_) {
      updateUnreadNotifications();
    });
  }

  Future<void> fetchLatestElection() async {
    final token = authController.token;

    if (token == null || token.isEmpty) {
      Get.snackbar(
        "Error",
        "No token found. Please log in first.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final url = Uri.parse('${GlobalConfig.backendUrl}/user/elections/latest');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authController.token}',
      },
    );

    try {
      print("Token Used: $token");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        final electionData = data['election'];

        if (electionData != null) {
          final Election election = Election.fromJson(electionData);
          electionName.value = election.name;

          final endDate = election.endDate;
          final currentTime = DateTime.now();
          final duration = endDate.difference(currentTime);

          remainingTime.value = duration.isNegative ? Duration.zero : duration;

          _startCountdown();
        } else {
          Get.snackbar(
            "Error",
            "No election data found in the response.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          errorData['message'] ?? "Failed to fetch election data.",
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

  void _startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.value > const Duration(seconds: 0)) {
        remainingTime.value -= const Duration(seconds: 1);
      } else {
        timer.cancel();
      }
    });
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final days = duration.inDays;
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$days days $hours:$minutes:$seconds";
  }

  void updateUnreadNotifications() {
    update();
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }
}
