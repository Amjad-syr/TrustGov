import 'package:flutter/material.dart';

class CustomElectionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomElectionCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFB0BEC5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFF3DA09D) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF3DA09D).withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF35444F) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
