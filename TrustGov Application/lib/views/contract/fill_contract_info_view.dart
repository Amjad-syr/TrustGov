import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/fill_contract_info_controller.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text_field.dart';

class FillContractInfoView extends StatelessWidget {
  final FillContractInfoController controller =
      Get.put(FillContractInfoController());

  FillContractInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF35444F),
      appBar: const CustomAppBar(title: "Fill Contract Info"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Contract Type",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: controller.contractType.value,
                items: controller.contractTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.contractType.value = value;
                    controller.clearFields();
                  }
                },
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              controller.contractType.value == "Buy Contract"
                  ? _buildBuyContractFields()
                  : _buildRentContractFields(),
              const SizedBox(height: 40),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuyContractFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: "Property ID",
                hintText: "Enter Property ID",
                controller: controller.propertyIdController,
              ),
            ),
            const SizedBox(width: 10),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        if (controller.propertyIdController.text
                            .trim()
                            .isNotEmpty) {
                          controller.fetchPropertyDetails(
                              controller.propertyIdController.text.trim());
                        } else {
                          Get.snackbar(
                            "Error",
                            "Please enter a valid Property ID.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3DA09D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.search, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: "Property Location",
          hintText: controller.propertyLocation.value.isEmpty
              ? "N/A"
              : controller.propertyLocation.value,
          isReadOnly: true,
        ),
        CustomTextField(
          label: "Description",
          hintText: controller.description.value.isEmpty
              ? "N/A"
              : controller.description.value,
          isReadOnly: true,
        ),
        CustomTextField(
          label: "Total Amount",
          hintText: "Enter Total Amount",
          controller: controller.totalAmountController,
        ),
        CustomTextField(
          label: "Paid Amount",
          hintText: "Enter Paid Amount",
          controller: controller.paidAmountController,
        ),
        CustomTextField(
          label: "Notes",
          hintText: "Enter Notes",
          controller: controller.notesController,
        ),
      ],
    );
  }

  Widget _buildRentContractFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: "Property ID",
                hintText: "Enter Property ID",
                controller: controller.propertyIdController,
              ),
            ),
            const SizedBox(width: 10),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        if (controller.propertyIdController.text
                            .trim()
                            .isNotEmpty) {
                          controller.fetchPropertyDetails(
                              controller.propertyIdController.text.trim());
                        } else {
                          Get.snackbar(
                            "Error",
                            "Please enter a valid Property ID.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3DA09D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.search, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: "Property Location",
          hintText: controller.propertyLocation.value.isEmpty
              ? "N/A"
              : controller.propertyLocation.value,
          isReadOnly: true,
        ),
        CustomTextField(
          label: "Seller Address",
          hintText: "Enter Seller Address",
          controller: controller.sellerAddressController,
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Get.toNamed('/join-contract-link');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3DA09D),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: const Text(
            "Join",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.contractType.value == "Buy Contract") {
              controller.createBuyRoom();
            } else {
              controller.createRentRoom();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3DA09D),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: const Text(
            "Next",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
