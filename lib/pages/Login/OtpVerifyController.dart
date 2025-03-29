import 'dart:developer';
import 'package:docon/pages/Admin/AdminBottomNavigation/AdminBottomNavigationScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Doctor/BottomNavigation/BottomNavigationScreen.dart';
import 'LoginPage.dart';

class OtpVerifyController extends GetxController {
  final List<TextEditingController> otpControllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  final supabase = Supabase.instance.client;

  String phoneNumber = "";
  var role = "".obs;

  static String? get baseUrl => dotenv.env['BASE_URL'];

  void setPhoneNumber(String number) {
    phoneNumber = number;
  }

  void setRole(String userRole) {
    role.value = userRole;
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }

  void onNumberSelected(int value) {
    if (value == -1) {
      for (int i = otpControllers.length - 1; i >= 0; i--) {
        if (otpControllers[i].text.isNotEmpty) {
          otpControllers[i].clear();
          focusNodes[i].requestFocus();
          break;
        }
      }
    } else {
      for (int i = 0; i < otpControllers.length; i++) {
        if (otpControllers[i].text.isEmpty) {
          otpControllers[i].text = value.toString();
          if (i < otpControllers.length - 1) {
            focusNodes[i + 1].requestFocus();
          } else {
            verifyOtp();
          }
          break;
        }
      }
    }
  }

  void verifyOtp() async {
    String otp = otpControllers.map((e) => e.text).join();

    if (otp.length != 4) {
      Get.snackbar('Error', 'Please enter a 4-digit OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phoneNumber,
          "countryCode": "+91",
          "otp": otp,
        }),
      );

      log("Verify OTP Response Status: ${response.statusCode}");
      log("Verify OTP Response Body: ${response.body}");

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        log("OTP Verified Successfully!");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userLoggedIn', role.value);

        Map<String, dynamic>? userDetails =
        await fetchUserDetailsByPhoneNumber(phoneNumber);

        if (userDetails == null) return;

        String userId = userDetails['id'];
        String authToken = data['authToken'] ?? '';
        await upsertAuthToken(userId, authToken);

        log('User authenticated, navigating to home screen.');

        if (role.value == 'doctor') {
          Get.offAll(() => BottomNavigationScreen(), arguments: userDetails);
        } else if (role.value == 'admin') {
          Get.offAll(() => AdminBottomNavigationScreen(), arguments: userDetails);
        }
      } else {
        log("OTP Verification Failed: ${data['error']}");
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
    String tableName = role.value == 'doctor' ? 'doctors' : 'admins';

    final response = await supabase
        .from(tableName)
        .select('*')
        .eq('phone_number', phone)
        .maybeSingle();

    log('Fetched user details for ${role.value} from $tableName: $response');

    if (response == null) {
      Get.snackbar(
        'Incorrect Role',
        'You have chosen the wrong role. Please select the correct role and try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      if (Get.currentRoute != '/login') {
        Future.delayed(const Duration(seconds: 3), () {
          Get.offAll(() => LoginPage());
        });
      }
      return null;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', response['id']);
    await prefs.setString('userName', response['name'] ?? '');
    await prefs.setString('userPhone', response['phone_number'] ?? '');

    if (role.value == 'doctor') {
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
    String upsertTableName =
    role.value == 'doctor' ? 'doctor_auth_tokens' : 'admin_auth_tokens';

    await supabase.from(upsertTableName).upsert({
      'user_id': userId,
      'auth_token': token,
      'created_at': DateTime.now().toIso8601String()
    }, onConflict: 'user_id');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    log('Auth token stored in SharedPreferences');
  }
}