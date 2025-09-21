import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final bool isPassword;
  final bool isReadOnly;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.isPassword = false,
    this.isReadOnly = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onChanged,
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
        TextFormField(
          readOnly: isReadOnly,
          obscureText: isPassword,
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white54),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
