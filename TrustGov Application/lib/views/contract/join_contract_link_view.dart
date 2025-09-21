import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/join_contract_link_controller.dart';
import '../../widgets/custom_appbar.dart';

class JoinContractLinkView extends StatelessWidget {
  final JoinContractLinkController controller =
      Get.put(JoinContractLinkController());

  JoinContractLinkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Join Contract Link"),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Join Contract",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF35444F),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Enter the contract link from the first party's mobile to complete the contract.",
                      style: TextStyle(fontSize: 15, color: Color(0xFF35444F)),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller.linkController,
                      decoration: InputDecoration(
                        hintText: "Enter Contract Link",
                        hintStyle: const TextStyle(color: Color(0xFF3DA09D)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: controller.verifyLink,
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
      ),
    );
  }
}
