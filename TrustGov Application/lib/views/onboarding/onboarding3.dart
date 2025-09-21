import 'package:flutter/material.dart';

class Onboarding3 extends StatelessWidget {
  final PageController controller;

  const Onboarding3({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF35444F),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text(
            "Easy Identity Verification",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Log in securely with AI-powered identity checks, designed to protect your personal information.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Color(0xFF757F8C)),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3DA09D),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.arrow_forward,
                    color: Color.fromARGB(255, 0, 0, 0), size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
