import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF2A3942),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            color: Color(0xFF3DA09D), size: 25),
        onPressed: () {
          Get.back();
        },
        tooltip: 'Back',
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF3DA09D),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
