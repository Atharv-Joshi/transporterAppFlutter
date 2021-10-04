import 'package:get/get.dart';

class TransporterIdController extends GetxController {
  RxString transporterId = "".obs;

  void updateTransporterId(String newValue) {
    transporterId.value = newValue;
  }

  RxBool transporterApproved = false.obs;

  void updateTransporterApproved(bool newValue) {
    transporterApproved.value = newValue;
  }

  RxBool companyApproved = false.obs;

  void updateCompanyApproved(bool newValue) {
    companyApproved.value = newValue;
  }

  RxString name = "".obs;

  void updateName(String newValue) {
    name.value = newValue;
  }

  RxString companyName = "".obs;

  void updateCompanyName(String newValue) {
    companyName.value = newValue;
  }

  RxBool accountVerificationInProgress = false.obs;

  void updateAccountVerificationInProgress(bool newValue) {
    accountVerificationInProgress.value = newValue;
  }

  RxString mobileNum = "".obs;

  void updateMobileNum(String newValue) {
    mobileNum.value = newValue;
  }

  RxString transporterLocation = "".obs;

  void updateTransporterLocation(String newValue) {
    transporterLocation.value = newValue;
  }

  RxString jmtToken = "".obs;

  void updateJmtToken(String newValue) {
    jmtToken.value = newValue;
  }
}
