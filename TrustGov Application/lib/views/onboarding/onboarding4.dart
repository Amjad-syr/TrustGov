import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding4 extends StatelessWidget {
  final PageController controller;

  const Onboarding4({super.key, required this.controller});

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingCompleted', true);
    Get.offNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF35444F),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text(
            "Faster Government Services",
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
              "TrustGov reduces paperwork and automates tasks like property registration and voting.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Color(0xFF757F8C)),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _completeOnboarding,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3DA09D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
