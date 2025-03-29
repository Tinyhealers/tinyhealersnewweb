import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Admin/AdminBottomNavigation/AdminBottomNavigationScreen.dart';
import '../Doctor/BottomNavigation/BottomNavigationScreen.dart';
import 'LoginPage.dart';
import 'OtpVerifyScreen.dart';

class PhoneNumberController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  RxBool isNewUser = true.obs; // Observable for reactive state
  final supabase = Supabase.instance.client;
  late String role;

  static String? get baseUrl => dotenv.env['BASE_URL'];

  void setRole(String roleValue) {
    role = roleValue;
  }

  Future<void> sendOtp() async {
    if (phoneController.text.isEmpty || phoneController.text.length < 10) {
      log("Valid phone number required");
      Get.snackbar('Error', 'Please enter a valid 10-digit phone number',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/send-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phoneController.text, "countryCode": "+91"}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        log("OTP sent successfully to ${phoneController.text}");

        Get.to(() => OtpVerifyScreen(
          phoneNumber: phoneController.text,
          role: role,
        ));
      } else {
        log("Failed to send OTP: ${data['message']}");
        Get.snackbar('Error','Failed to send OTP',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      log("Error sending OTP: $e");
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> verifyOtp(String otp) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phoneController.text, "otp": otp}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['verified'] == true) {
        log("OTP Verified Successfully!");

        // Fetch user details
        Map<String, dynamic>? userDetails =
        await fetchUserDetailsByPhoneNumber(phoneController.text);

        if (userDetails == null) return; // Stop if user details are null

        String userId = userDetails['id'];

        // Store authentication token
        String authToken = data['authToken'] ?? '';
        await upsertAuthToken(userId, authToken);

        log('User authenticated, navigating to home screen.');

        if (role == 'doctor') {
          Get.offAll(() => BottomNavigationScreen(), arguments: userDetails);
        } else if (role == 'admin') {
          Get.offAll(() => AdminBottomNavigationScreen(), arguments: userDetails);
        }
      } else {
        log("OTP Verification Failed: ${data['message']}");
        Get.snackbar('Error','OTP verification failed',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      log("Error verifying OTP: $e");
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<Map<String, dynamic>?> fetchUserDetailsByPhoneNumber(String phone) async {
    String tableName = role == 'doctor' ? 'doctors' : 'admins';

    final response = await supabase
        .from(tableName)
        .select('*')
        .eq('phone_number', phone)
        .maybeSingle();

    log('Fetched user details for $role from $tableName: $response');

    if (response == null) {
      Get.snackbar(
        'Incorrect Role',
        'You have chosen the wrong role. Please select the correct role and try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      if (Get.currentRoute != '/login') {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => LoginPage());
        });
      }
      return null;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', response['id']);
    await prefs.setString('userName', response['name'] ?? '');
    await prefs.setString('userPhone', response['phone_number'] ?? '');
    await prefs.setString('userLoggedIn', role);

    if (role == 'doctor') {
      await prefs.setString('degree', response['degree'] ?? '');
      await prefs.setInt('experience', response['experience'] ?? 0);
      await prefs.setString('hospitalName', response['hospital_name'] ?? '');
      await prefs.setBool('isOnline', response['is_online'] ?? false);
    } else {
      await prefs.setString('userEmail', response['email'] ?? '');
    }

    return response;
  }

  Future<void> upsertAuthToken(String userId, String token) async {
    String upsertTableName = role == 'doctor' ? 'doctor_auth_tokens' : 'admin_auth_tokens';

    await supabase.from(upsertTableName).upsert({
      'user_id': userId,
      'auth_token': token,
      'created_at': DateTime.now().toIso8601String()
    }, onConflict: 'user_id');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    log('Auth token stored in SharedPreferences');
  }

  void updatePhoneNumber(String value) {
    if (value == '-1') {
      if (phoneController.text.isNotEmpty) {
        phoneController.text =
            phoneController.text.substring(0, phoneController.text.length - 1);
      }
    } else if (phoneController.text.length < 10) {
      phoneController.text += value;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
