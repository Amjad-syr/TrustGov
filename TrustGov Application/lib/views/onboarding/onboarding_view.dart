import 'package:flutter/material.dart';
import 'onboarding1.dart';
import 'onboarding2.dart';
import 'onboarding3.dart';
import 'onboarding4.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              Onboarding1(controller: _pageController),
              Onboarding2(controller: _pageController),
              Onboarding3(controller: _pageController),
              Onboarding4(controller: _pageController),
            ],
          ),
          if (_currentPage < 3)
            Positioned(
              bottom: 30,
              left: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                  4,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFF3DA09D)
                          : const Color(0xFF2A3942),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
