import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/candidate_model.dart';
import '../BackendUrl.dart';
import 'AuthController.dart';

class ElectionResultController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  var results = <Candidate>[].obs;
  var totalVotes = 0.obs;
  var userCount = 0.obs;
  var electionName = ''.obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchElectionResults();
  }

  Future<void> fetchElectionResults() async {
    try {
      final url = Uri.parse('${GlobalConfig.backendUrl}/user/elections/latest');
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authController.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        if (data != null) {
          electionName.value = data['election']?['name'] ?? 'Unknown Election';
          totalVotes.value = data['totalvotes'] ?? 0;
          userCount.value = data['usercount'] ?? 0;
          results.value = (data['candidates'] as List<dynamic>?)
                  ?.map((candidate) => Candidate.fromJson(candidate))
                  .toList() ??
              [];
        } else {
          hasError.value = true;
          errorMessage.value = "No data found in the response.";
        }
      } else {
        final errorData = jsonDecode(response.body);
        hasError.value = true;
        errorMessage.value =
            errorData['message'] ?? "Failed to fetch election results.";
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "An unexpected error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
