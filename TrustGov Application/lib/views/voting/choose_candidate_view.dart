import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/choose_candidate_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/candidate_option.dart';

class ChooseCandidateView extends StatelessWidget {
  final ChooseCandidateController controller =
      Get.put(ChooseCandidateController());

  ChooseCandidateView({super.key});

  @override
  Widget build(BuildContext context) {
    final String electionName =
        Get.arguments?['election']?['name'] ?? "Presidential Election";

    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Choose Candidate"),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "TRUSTGOV",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    electionName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF35444F),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: controller.candidates.length,
                        itemBuilder: (context, index) {
                          final candidate = controller.candidates[index];
                          final isSelected =
                              controller.selectedCandidate.value == candidate;

                          return CandidateOption(
                            name: candidate.name,
                            isSelected: isSelected,
                            onTap: () {
                              controller.selectCandidate(candidate);
                            },
                          );
                        },
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed: controller.selectedCandidate.value != null
                            ? () => _showConfirmationPopup(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3DA09D),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationPopup(BuildContext context) {
    final candidateName = controller.selectedCandidate.value?.name ?? "";
    final candidate = controller.selectedCandidate.value;

    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: Text("Are you sure you want to vote for $candidateName?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed('/verify-identity', arguments: {
                "candidate": candidate?.toJson(),
                "election": Get.arguments?['election'],
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3DA09D)),
            child: const Text(
              "Continue",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
