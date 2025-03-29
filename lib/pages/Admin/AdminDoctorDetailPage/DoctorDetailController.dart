import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../constants/colors.dart';

class DoctorDetailController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final RxBool isLoading = false.obs;
  final RxBool isOnline = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController hospitalController = TextEditingController();

  late String doctorId;

  void setDoctorDetails(Map<String, dynamic> doctor) {
    doctorId = doctor['id'];
    nameController.text = doctor['name'];
    degreeController.text = doctor['degree'];
    experienceController.text = doctor['experience'].toString();
    phoneController.text = doctor['phone_number'];
    hospitalController.text = doctor['hospital_name'] ?? '';
    isOnline.value = doctor['is_online'];
  }

  Future<void> updateDoctor() async {
    isLoading.value = true;
    try {
      await supabase.from('doctors').update({
        'name': nameController.text.trim(),
        'degree': degreeController.text.trim(),
        'experience': int.parse(experienceController.text.trim()),
        'phone_number': phoneController.text.trim(),
        'hospital_name': hospitalController.text.trim().isEmpty ? null : hospitalController.text.trim(),
        'is_online': isOnline.value,
        'last_updated': DateTime.now().toIso8601String(),
      }).eq('id', doctorId);

      Get.snackbar('Success', 'Doctor details updated!', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update doctor.', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDoctor() async {
    isLoading.value = true;
    try {
      await supabase.from('doctors').delete().eq('id', doctorId);
      Get.snackbar('Success', 'Doctor deleted successfully!', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete doctor.', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

}


