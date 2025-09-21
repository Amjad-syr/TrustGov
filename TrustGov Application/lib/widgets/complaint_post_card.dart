import 'package:flutter/material.dart';
import '../../models/complaint_model.dart';
import '../../controllers/complaint_controller.dart';

class ComplaintPostCard extends StatelessWidget {
  final ComplaintModel complaint;
  final ComplaintController controller;

  const ComplaintPostCard({
    super.key,
    required this.complaint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildImage(complaint.picturePath1)),
              const SizedBox(width: 10),
              Expanded(child: _buildImage(complaint.picturePath2)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            complaint.desc,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF35444F),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Location: ${complaint.location}",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildVoteButton(
                icon: Icons.thumb_up_alt_rounded,
                color: complaint.isUpvoted.value ? Colors.green : Colors.grey,
                onTap: () => controller.voteComplaint(complaint.id, 1),
                label: "Upvote",
              ),
              _buildVoteButton(
                icon: Icons.thumb_down_alt_rounded,
                color: complaint.isDownvoted.value ? Colors.red : Colors.grey,
                onTap: () => controller.voteComplaint(complaint.id, 0),
                label: "Downvote",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                "Failed to load image",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVoteButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
