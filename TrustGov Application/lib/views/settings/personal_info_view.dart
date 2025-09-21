import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/personal_info_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text_field.dart';

class PersonalInfoView extends StatelessWidget {
  final PersonalInfoController controller = Get.put(PersonalInfoController());

  PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Personal Information"),
      backgroundColor: const Color(0xFF35444F),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(() => CustomTextField(
                  label: "National Number",
                  hintText: controller.nationalNumber.value,
                  isReadOnly: true,
                )),
            const SizedBox(height: 15),
            Obx(() => CustomTextField(
                  label: "Full Name",
                  hintText: controller.fullName.value,
                  isReadOnly: true,
                )),
            const SizedBox(height: 15),
            Obx(() => CustomTextField(
                  label: "Father Name",
                  hintText: controller.fatherName.value,
                  isReadOnly: true,
                )),
            const SizedBox(height: 15),
            Obx(() => CustomTextField(
                  label: "Mother Name",
                  hintText: controller.motherName.value,
                  isReadOnly: true,
                )),
            const SizedBox(height: 15),
            Obx(() => CustomTextField(
                  label: "Birth Date",
                  hintText: controller.birthDate.value,
                  isReadOnly: true,
                )),
          ],
        ),
      ),
    );
  }
}
