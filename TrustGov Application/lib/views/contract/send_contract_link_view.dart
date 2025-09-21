import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/send_contract_link_controller.dart';
import '../../widgets/custom_appbar.dart';

class SendContractLinkView extends StatelessWidget {
  final SendContractLinkController controller =
      Get.put(SendContractLinkController());

  SendContractLinkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Send Contract Link"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Contract Link",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF35444F),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Send the link to the other party of the contract and wait for them to enter.",
                    style: TextStyle(fontSize: 15, color: Color(0xFF35444F)),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.contractLink.value,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3DA09D),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.copy,
                              color: Color(0xFF3DA09D),
                            ),
                            onPressed: controller.copyToClipboard,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: controller.navigateToFinalizeContract,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3DA09D),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
