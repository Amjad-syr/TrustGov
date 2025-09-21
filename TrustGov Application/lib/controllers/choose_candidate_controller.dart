import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/candidate_model.dart';
import '../BackendUrl.dart';
import 'AuthController.dart';

class ChooseCandidateController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  var candidates = <Candidate>[].obs;
  var selectedCandidate = Rxn<Candidate>();
  late int electionId;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null && arguments['election_id'] != null) {
      electionId = arguments['election_id'];
      fetchCandidates(electionId);
    } else {
      Get.snackbar("Error", "No election ID provided.");
    }
  }

  Future<void> fetchCandidates(int electionId) async {
    try {
      final url = Uri.parse(
          '${GlobalConfig.backendUrl}/user/elections/$electionId/candidates');
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'] as List;
        candidates.value = responseData
            .map((candidate) => Candidate.fromJson(candidate))
            .toList();
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
            "Error", errorData['message'] ?? "Failed to fetch candidates.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }

  void selectCandidate(Candidate candidate) {
    selectedCandidate.value = candidate;
  }
}
