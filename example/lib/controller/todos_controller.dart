import 'package:getx/getx.dart';

class TodosController extends GetxController {
  static TodosController get to => Get.find();
  RxList<String> todos = <String>[].obs;
}
