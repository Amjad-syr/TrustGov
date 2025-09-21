import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/choose_election_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_election_card.dart';

class ChooseElectionView extends StatelessWidget {
  final ChooseElectionController controller =
      Get.put(ChooseElectionController());

  ChooseElectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Choose Election"),
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
                  const Text(
                    "Current Elections",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF35444F),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: controller.elections.length,
                        itemBuilder: (context, index) {
                          final election = controller.elections[index];
                          final isSelected =
                              controller.selectedElection.value == election;

                          return CustomElectionCard(
                            title: election.name,
                            isSelected: isSelected,
                            onTap: () {
                              controller.selectElection(election);
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
                        onPressed: controller.selectedElection.value != null
                            ? () {
                                controller.navigateToChooseCandidate();
                              }
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
}
