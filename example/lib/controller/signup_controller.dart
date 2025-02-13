import 'dart:convert';

import 'package:example/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:getx/getx.dart';

class SignupController extends GetxController {
  static SignupController get to => Get.find();

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  GetConnect http = GetConnect(
    allowAutoSignedCert: true,
    followRedirects: true,
    maxRedirects: 5,
  );

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void chackSignup() async {
    if (emailController.text.isEmpty) {
      showMassage(
        title: "Worning",
        message: 'Please enter your email address',
        icon: Icons.error,
        iconColor: Colors.redAccent,
      );
    } else if (passwordController.text.isEmpty) {
      showMassage(
        title: "Worning",
        message: 'Please enter your password',
        icon: Icons.error,
        iconColor: Colors.redAccent,
      );
    } else if (confirmPasswordController.text.isEmpty) {
      showMassage(
        title: "Worning",
        message: 'Please enter your confirm password',
        icon: Icons.error,
        iconColor: Colors.redAccent,
      );
    } else if (!GetUtils.isEmail(emailController.text)) {
      showMassage(
        title: "Worning",
        message: 'Please enter a valid email',
        icon: Icons.error,
        iconColor: Colors.redAccent,
      );
    } else if (passwordController.text.length > 6) {
      showMassage(
        title: "Worning",
        message: 'Password must be at least 6 characters',
        icon: Icons.error,
        iconColor: Colors.redAccent,
      );
    } else if (passwordController.text != confirmPasswordController.text) {
      showMassage(
        title: "Worning",
        message: 'Password does not match',
        icon: Icons.error,
        iconColor: Colors.redAccent,
      );
    } else {
      Get.showOverlay(
        asyncFunction: () => signUp(),
        opacity: 1,
        loadingWidget: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }
  }

  Future<UserModel?> signUp() async {
    final baseUrl = 'http://192.168.1.103/todos/';
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    var body = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    final response = await http.post(
      '$baseUrl/register',
      headers: header,
      body,
    );

    var jsonData = json.decode(response.bodyString!);

    if (jsonData is Map) {
      bool success = jsonData['success'];
      String message = jsonData['message'];

      if (success) {
        UserModel user = UserModel.fromJson(jsonData['data']);
        showMassage(
          title: "Success",
          message: message,
          icon: Icons.check,
          iconColor: Colors.green,
        );
        Get.back();
        return user;
      } else {
        showMassage(
          title: "Error",
          message: message,
          icon: Icons.error,
          iconColor: Colors.redAccent,
        );
      }
    } else {
      showMassage(
        title: "Error",
        message: 'Something went wrong',
        icon: Icons.error,
        iconColor: Colors.redAccent,
      );
    }
    return null;
  }

  void showMassage({required String title, required String message, required IconData icon, required Color iconColor}) {
    Get.snackbar(
      title,
      message,
      barBlur: 0.8,
      borderRadius: 12.0,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(icon, color: iconColor),
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.all(20.0),
      mainButton: TextButton(
        child: Text('Retry', style: TextStyle(color: Colors.white)),
        onPressed: () {
          // Perform operation to reconnect
          Get.back(); // Close the snackbar
        },
      ),
      duration: Duration(seconds: 5),
      backgroundColor: Colors.grey[800]!,
    );
  }
}
