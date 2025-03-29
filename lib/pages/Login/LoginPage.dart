import 'package:docon/pages/Login/PhoneNumberScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart'; // Ensure you have this file with the color constants
import 'privacy_policy.dart'; // Ensure this file exists and contains privacy policy text

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: isDesktop
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left Side (Text & Buttons)
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor1,
                        ),
                      ),
                      Text(
                        'Tiny',
                        style: TextStyle(
                          fontSize: 68,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor1,
                        ),
                      ),
                      Text(
                        'Healers',
                        style: TextStyle(
                          fontSize: 68,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor1,
                        ),
                      ),
                      SizedBox(height: 20),
                      LoginButton(
                        title: 'Doctor Login',
                        color: AppColors.primaryColor,
                        textColor: Colors.white,
                        border: false,
                        onPressed: () {
                          Get.to(() => PhoneNumberScreen(role: 'doctor'));
                        },
                      ),
                      SizedBox(height: 16),
                      LoginButton(
                        title: 'Admin Login',
                        color: Colors.transparent,
                        textColor: AppColors.primaryColor,
                        border: true,
                        onPressed: () {
                          Get.to(() => PhoneNumberScreen(role: 'admin'));
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Secure & Reliable Healthcare Management',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor2,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 50),
                // Right Side (Image)
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'web/icons/loginpage.jpg',
                      width: MediaQuery.of(context).size.width * 0.3,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            )
                : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'web/icons/loginpage.jpg',
                      width: MediaQuery.of(context).size.width * 0.9,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor1,
                    ),
                  ),
                  Text(
                    'Tiny',
                    style: TextStyle(
                      fontSize: 68,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor1,
                    ),
                  ),
                  Text(
                    'Healers',
                    style: TextStyle(
                      fontSize: 68,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor1,
                    ),
                  ),
                  SizedBox(height: 20),
                  LoginButton(
                    title: 'Doctor Login',
                    color: AppColors.primaryColor,
                    textColor: Colors.white,
                    border: false,
                    onPressed: () {
                      Get.to(() => PhoneNumberScreen(role: 'doctor'));
                    },
                  ),
                  SizedBox(height: 16),
                  LoginButton(
                    title: 'Admin Login',
                    color: Colors.transparent,
                    textColor: AppColors.primaryColor,
                    border: true,
                    onPressed: () {
                      Get.to(() => PhoneNumberScreen(role: 'admin'));
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Secure & Reliable Healthcare Management',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textColor2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// **Login Button Widget**
class LoginButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final bool border;
  final VoidCallback onPressed;

  const LoginButton({
    required this.title,
    required this.color,
    required this.textColor,
    required this.border,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: border ? BorderSide(color: AppColors.primaryColor, width: 2) : BorderSide.none,
          ),
          elevation: border ? 0 : 5,
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}