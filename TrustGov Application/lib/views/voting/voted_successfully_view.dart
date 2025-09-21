import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_appbar.dart';

class VotedSuccessfullyView extends StatelessWidget {
  const VotedSuccessfullyView({super.key});

  @override
  Widget build(BuildContext context) {
    final String candidateName =
        Get.arguments?['candidate'] ?? "the selected candidate";

    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Voted Successfully"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
              const SizedBox(height: 20),
              const Text(
                "You have voted for",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "candidate $candidateName successfully.",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Get.offAllNamed('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3DA09D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Back to Home",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
