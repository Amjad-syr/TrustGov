import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_appbar.dart';

class AccountCreatedView extends StatelessWidget {
  const AccountCreatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Account Created"),
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
            const SizedBox(height: 20),
            const Text(
              "Your account has been created successfully.",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.offAllNamed('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3DA09D),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Back to Login",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
