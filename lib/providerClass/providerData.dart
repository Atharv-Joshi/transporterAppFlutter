import 'package:flutter/material.dart';

class ProviderData extends ChangeNotifier {
  int index = 0;

  String loadingPointCity = "";
  String loadingPointState = "";

  String unloadingPointCity = "";
  String unloadingPointState = "";

  // variables for login pages

  bool inputControllerLengthCheck = false;
  dynamic buttonColor = MaterialStateProperty.all<Color>(Colors.grey);
  String smsCode = '';
  String phoneController = '';

  // variables for add truck pages

  String truckTypeButtonId = '';
  int passingWeightButtonId = 0;
  int truckLengthButtonId = 0;
  int totalTyresButtonId = 0;

  //------------------------

  void clearLoadingPoint() {
    loadingPointCity = "";
    loadingPointState = "";
    notifyListeners();
  }

  void clearUnloadingPoint() {
    unloadingPointCity = "";
    unloadingPointState = "";
    notifyListeners();
  }

  void updateLoadingPoint({required String city, required String state}) {
    loadingPointCity = city;
    loadingPointState = state;
    notifyListeners();
  }

  void updateUnloadingPoint({required String city, required String state}) {
    unloadingPointCity = city;
    unloadingPointState = state;
    notifyListeners();
  }

  void updateIndex(int newValue) {
    index = newValue;
    notifyListeners();
  }

  //for login screen

  void updatePhoneController(String value) {
    phoneController = value;
    print(phoneController);
    notifyListeners();
  }

  void updateInputControllerLengthCheck(bool value) {
    inputControllerLengthCheck = value;
    notifyListeners();
  }

  void updateButtonColor(dynamic value) {
    buttonColor = value;
    notifyListeners();
  }

  void updateSmsCode(value) {
    smsCode = value;
    notifyListeners();
  }

  void clearall() {
    inputControllerLengthCheck = false;
    buttonColor = MaterialStateProperty.all<Color>(Colors.grey);

    smsCode = '';
    notifyListeners();
  }
//-------------------------------------

void updateTruckTypeButtonId(value){
    truckTypeButtonId = value;
    notifyListeners();
}

  void updatePassingWeightButtonId(value){
    passingWeightButtonId = value;
    notifyListeners();
  }

  void updateTruckLengthButtonId(value){
    truckLengthButtonId = value;
    notifyListeners();
  }

  void updateTotalTyresButtonId(value){
    totalTyresButtonId = value;
    notifyListeners();
  }

}
