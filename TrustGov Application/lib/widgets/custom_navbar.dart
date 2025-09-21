import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNavBar extends StatelessWidget {
  final String activePage;

  const CustomNavBar({super.key, required this.activePage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        color: Color(0xFF2A3942),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.bar_chart, "Stats", '/stats', activePage),
          _navIcon(Icons.check_box, "Vote", '/choose-election', activePage),
          _navIcon(Icons.home, "Home", '/home', activePage),
          _navIcon(
              Icons.edit_square, "Contract", '/fill-contract-info', activePage),
          _navIcon(Icons.settings, "Settings", '/settings', activePage),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, String label, String route, String active) {
    final bool isActive = active == route;

    return InkWell(
      onTap: () {
        if (!isActive) {
          Get.toNamed(route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: isActive ? const Color(0xFF3DA09D) : Colors.white,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF3DA09D) : Colors.white,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
