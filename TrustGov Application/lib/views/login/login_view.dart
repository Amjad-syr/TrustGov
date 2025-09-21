import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/login_text_field.dart';

class LoginView extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final nationalNumberController = TextEditingController();
  final passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.7,
              ),
              const SizedBox(height: 10),
              LoginTextField(
                label: "National Number",
                controller: nationalNumberController,
              ),
              const SizedBox(height: 20),
              Obx(() => LoginTextField(
                    label: "Password",
                    controller: passwordController,
                    isPassword: true,
                    isPasswordVisible: loginController.isPasswordVisible.value,
                    onPasswordToggle: loginController.togglePasswordVisibility,
                  )),
              const SizedBox(height: 20),
              Obx(() => loginController.isLoading.value
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: "Sign in",
                      onPressed: () {
                        loginController.login(
                          nationalNumberController.text,
                          passwordController.text,
                        );
                      },
                    )),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/signup1');
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3DA09D),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
