import 'package:flutter/material.dart';
import 'package:getx/getx.dart';

class TodosController extends GetxController {
  static TodosController get to => Get.find();

  final ValueNotifier<ScrollNotification?> notifier = ValueNotifier(null);

  final RxList<String> todos = <String>[].obs;
}
