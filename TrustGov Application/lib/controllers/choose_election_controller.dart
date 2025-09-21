// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/election_model.dart';
import '../BackendUrl.dart';
import 'AuthController.dart';

class ChooseElectionController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  var elections = <Election>[].obs;
  var selectedElection = Rxn<Election>();

  @override
  void onInit() {
    super.onInit();
    fetchActiveElections();
  }

  Future<void> fetchActiveElections() async {
    try {
      final url = Uri.parse('${GlobalConfig.backendUrl}/user/elections/active');
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'] as List;
        elections.value = responseData
            .map((election) => Election.fromJson(election))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
            "Error", errorData['message'] ?? "Failed to fetch elections.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }

  void selectElection(Election election) {
    selectedElection.value = election;
  }

  Future<void> navigateToChooseCandidate() async {
    if (selectedElection.value != null) {
      try {
        final url = Uri.parse(
            '${GlobalConfig.backendUrl}/user/elections/${selectedElection.value!.id}/has-voted');
        final response = await http.get(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${authController.token}',
          },
        );
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body)['data'];
          if (data == true) {
            Get.snackbar(
              "Already Voted",
              "You have already voted in this election and cannot vote again.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          } else {
            Get.toNamed(
              '/choose-candidate',
              arguments: {
                'election': selectedElection.value!.toJson(),
                'election_id': selectedElection.value!.id,
              },
            );
          }
        } else {
          final errorData = jsonDecode(response.body);
          Get.snackbar(
            "Error",
            errorData['message'] ?? "Failed to check voting status.",
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
}
