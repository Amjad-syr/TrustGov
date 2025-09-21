import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/finalize_contract_controller.dart';
import '../../widgets/custom_appbar.dart';

class FinalizeContractView extends StatelessWidget {
  final FinalizeContractController controller =
      Get.put(FinalizeContractController());

  FinalizeContractView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Finalize Contract"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Contract Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF35444F),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildContractLink(),
                      const SizedBox(height: 20),
                      _buildSection("Contract Information",
                          controller.contractInformation),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildContractLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Room Code:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: controller.copyLinkToClipboard,
          child: Row(
            children: [
              Obx(() => Text(
                    controller.roomCode.value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3DA09D),
                      decoration: TextDecoration.underline,
                    ),
                  )),
              const SizedBox(width: 5),
              const Icon(
                Icons.copy,
                color: Color(0xFF3DA09D),
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, Map<String, String> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF35444F),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: data.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: controller.buyerConfirmed.value ? null : () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.buyerConfirmed.value
                  ? Colors.green
                  : const Color(0xFF3DA09D),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: controller.buyerConfirmed.value
                ? const Icon(Icons.check, color: Colors.white)
                : const Text(
                    "Buyer Pending",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),
          ElevatedButton(
            onPressed: controller.sellerConfirmed.value
                ? null
                : () async {
                    await controller.confirmAsSeller();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.sellerConfirmed.value
                  ? Colors.green
                  : const Color(0xFF3DA09D),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: controller.sellerConfirmed.value
                ? const Icon(Icons.check, color: Colors.white)
                : const Text(
                    "Seller Accept",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}
