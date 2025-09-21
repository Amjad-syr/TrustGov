import 'package:flutter/material.dart';

class CandidateOption extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const CandidateOption({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF3DA09D) : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF3DA09D).withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF35444F) : Colors.grey,
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color:
                  isSelected ? const Color(0xFF3DA09D) : Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
