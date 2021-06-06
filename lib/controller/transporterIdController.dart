import 'package:get/get.dart';

class TransporterIdController extends GetxController{
  RxString transporterId = "".obs;
  void updateTransporterId(String newValue){
    transporterId.value = newValue;
  }
  RxBool transporterApproved = false.obs;
  void updateTransporterApproved(bool newValue){
    transporterApproved.value = newValue;
    print(transporterApproved.value);
  }
  RxBool companyApproved = false.obs;
  void updateCompanyApproved(bool newValue){
    companyApproved.value = newValue;
    print(companyApproved.value);
  }
}