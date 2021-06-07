import 'package:get/get.dart';

class ButtonBackgroundColorController extends GetxController{
  RxBool active = false.obs;

  void updateButtonState(bool value){
    active.value = value;
  }
}