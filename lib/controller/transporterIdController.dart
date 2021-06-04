import 'package:get/get.dart';

class TransporterIdController extends GetxController{
  RxString transporterId = "".obs;
  void updateTransporterId(String newValue){
    transporterId.value = newValue;
  }
}