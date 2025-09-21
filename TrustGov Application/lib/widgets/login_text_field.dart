import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final bool isPasswordVisible;
  final Function()? onPasswordToggle;

  const LoginTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onPasswordToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF3DA09D),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                    onPressed: onPasswordToggle,
                  )
                : null,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            hintStyle: const TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
