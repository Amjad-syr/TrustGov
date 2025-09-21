import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/complaint_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class CreateComplaintView extends StatelessWidget {
  final ComplaintController controller = Get.put(ComplaintController());

  CreateComplaintView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Create Complaint"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              label: "Description",
              hintText: "Enter the complaint description",
              controller: controller.descController,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              label: "Location",
              hintText: "Enter the location",
              controller: controller.locationController,
            ),
            const SizedBox(height: 15),
            _buildImageUploadSection("Upload Image 1", 1),
            const SizedBox(height: 15),
            _buildImageUploadSection("Upload Image 2", 2),
            const SizedBox(height: 30),
            CustomButton(
              text: "Post",
              onPressed: controller.createComplaint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadSection(String label, int index) {
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
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => controller.pickImage(index),
          child: Obx(() {
            final image = index == 1
                ? controller.picture1.value
                : controller.picture2.value;
            return Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
            );
          }),
        ),
      ],
    );
  }
}
