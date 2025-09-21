import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/AuthController.dart';
import '../../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 6));

    final prefs = await SharedPreferences.getInstance();
    final bool isOnboardingCompleted =
        prefs.getBool('isOnboardingCompleted') ?? false;

    final authController = Get.find<AuthController>();
    final String? token = authController.token;

    if (isOnboardingCompleted) {
      if (token != null && token.isNotEmpty) {
        Get.offNamed(AppRoutes.home);
      } else {
        Get.offNamed(AppRoutes.login);
      }
    } else {
      Get.offNamed(AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'assets/images/logo.png',
            width: MediaQuery.of(context).size.width * 1.5,
            height: MediaQuery.of(context).size.width * 1.5,
          ),
        ),
      ),
    );
  }
}
