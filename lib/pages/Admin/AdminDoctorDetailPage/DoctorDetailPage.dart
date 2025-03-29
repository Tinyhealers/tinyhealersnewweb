import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import 'DoctorDetailController.dart';

class DoctorDetailPage extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final DoctorDetailController controller = Get.put(DoctorDetailController());

  DoctorDetailPage({super.key, required this.doctor}) {
    controller.setDoctorDetails(doctor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Doctor Details',
          style: TextStyle(color: AppColors.primaryColor),
        ),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: Colors.black, size: 30),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLargeScreen = constraints.maxWidth > 800;

          return isLargeScreen
              ? Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 600,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInputField('Name', controller.nameController),
                        _buildInputField('Degree', controller.degreeController),
                        _buildInputField('Experience', controller.experienceController, isNumeric: true),
                        _buildInputField('Hospital (Optional)', controller.hospitalController),
                        _buildInputField('Phone Number', controller.phoneController, isNumeric: true, isEditable: false),
                        const SizedBox(height: 8),
                        Obx(
                              () => SwitchListTile(
                            title: const Text('Doctor is Online'),
                            value: controller.isOnline.value,
                            onChanged: (val) => controller.isOnline.value = val,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBottomBar(),
                ],
              ),
            ),
          )
              : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildInputField('Name', controller.nameController),
                      _buildInputField('Degree', controller.degreeController),
                      _buildInputField('Experience', controller.experienceController, isNumeric: true),
                      _buildInputField('Hospital (Optional)', controller.hospitalController),
                      _buildInputField('Phone Number', controller.phoneController, isNumeric: true, isEditable: false),
                      const SizedBox(height: 8),
                      Obx(
                            () => SwitchListTile(
                          title: const Text('Doctor is Online'),
                          value: controller.isOnline.value,
                          onChanged: (val) => controller.isOnline.value = val,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width <= 800 ? _buildMobileBottomBar() : null,
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isNumeric = false, bool isEditable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          readOnly: !isEditable,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: !isEditable,
            fillColor: isEditable ? Colors.white : Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: _buildButtonRow(),
    );
  }

  Widget _buildMobileBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: _buildButtonRow(),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showDeleteConfirmationDialog(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text('Delete', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.updateDoctor(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Update', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog() {
    Get.defaultDialog(
      title: "Confirm Delete",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      middleText: "Are you sure you want to delete this doctor?",
      middleTextStyle: const TextStyle(fontSize: 16, color: Colors.black87),
      radius: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteDoctor();
        Get.back();
        Get.back();
      },
    );
  }
}
