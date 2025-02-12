import 'package:flutter/widgets.dart';
import 'package:getx/getx.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void onInit() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
