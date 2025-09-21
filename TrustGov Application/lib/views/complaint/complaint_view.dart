import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/complaint_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/complaint_post_card.dart';

class ComplaintsView extends StatelessWidget {
  final ComplaintController controller = Get.put(ComplaintController());

  ComplaintsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Complaints"),
      backgroundColor: const Color(0xFF35444F),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/create-complaint'),
        backgroundColor: const Color(0xFF3DA09D),
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.complaints.length,
          itemBuilder: (context, index) {
            final complaint = controller.complaints.reversed.toList()[index];
            return ComplaintPostCard(
              complaint: complaint,
              controller: controller,
            );
          },
        ),
      ),
    );
  }
}
