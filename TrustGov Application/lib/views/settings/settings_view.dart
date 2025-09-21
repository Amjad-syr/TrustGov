import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/logout_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_navbar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Settings"),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        children: [
          _buildSettingsOption(
            label: "Complaints",
            icon: Icons.report_outlined,
            onTap: () => Get.toNamed(AppRoutes.complaints),
          ),
          _buildSettingsOption(
            label: "Notification",
            icon: Icons.notifications_outlined,
            onTap: () => Get.toNamed('/notifications'),
          ),
          _buildSettingsOption(
            label: "Personal Information",
            icon: Icons.person_outline,
            onTap: () => Get.toNamed('/personal-info'),
          ),
          _buildSettingsOption(
            label: "Logout",
            icon: Icons.logout_outlined,
            onTap: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(activePage: '/settings'),
    );
  }

  Widget _buildSettingsOption({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
    IconData? trailingIcon,
    Color? trailingColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF35444F), size: 28),
                const SizedBox(width: 15),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF35444F),
                  ),
                ),
              ],
            ),
            if (trailingIcon != null)
              Icon(trailingIcon,
                  color: trailingColor ?? Colors.black45, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final logoutController = Get.put(LogoutController());

    Get.dialog(
      AlertDialog(
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF35444F),
          ),
        ),
        content: const Text("Are you sure you want to log out of your account?",
            style: TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel",
                style: TextStyle(color: Color(0xFF3DA09D))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3DA09D),
            ),
            onPressed: () async {
              Get.back();
              await logoutController.logout();
            },
            child: const Text("Logout",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          ),
        ],
      ),
    );
  }
}
