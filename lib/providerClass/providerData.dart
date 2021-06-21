import 'dart:io';

import 'package:flutter/material.dart';

class ProviderData extends ChangeNotifier {
  int index = 0;

  String loadingPointCityFindLoad = "";
  String loadingPointStateFindLoad = "";

  String unloadingPointCityFindLoad = "";
  String unloadingPointStateFindLoad = "";

  String loadingPointCityPostLoad = "";
  String loadingPointStatePostLoad = "";

  String unloadingPointCityPostLoad = "";
  String unloadingPointStatePostLoad = "";

  String bookingDate = "";

  // variables for accountVerification
  File? profilePhotoFile;
  File? panFrontPhotoFile;
  File? panBackPhotoFile;
  File? addressProofPhotoFile;
  File? companyIdProofPhotoFile;

  // variables for login pages

  bool inputControllerLengthCheck = false;
  dynamic buttonColor = MaterialStateProperty.all<Color>(Colors.grey);
  String smsCode = '';
  String phoneController = '';

  //-------------------------------------

  // variables for add truck pages

  String truckTypeValue = '';
  String productType = 'Choose Product Type';
  int passingWeightValue = 0;
  int totalTyresValue = 0;
  int truckLengthValue = 0;
  String driverIdValue = '';
  String truckNumberValue = '';
  int truckNumber = 0;

  String truckId = '';

  //variables related to rest button
  bool resetActive = false;

  //variables related to driverApi
  List driverList = [];

  updateProfilePhoto(File newFile) {
    profilePhotoFile = newFile;
    notifyListeners();
  }

  updatePanFrontPhoto(File newFile) {
    panFrontPhotoFile = newFile;
    notifyListeners();
  }

  updatePanBackPhoto(File newFile) {
    panBackPhotoFile = newFile;
    notifyListeners();
  }

  updateAddressProofPhoto(File newFile) {
    addressProofPhotoFile = newFile;
    notifyListeners();
  }

  updateCompanyIdProofPhoto(File newFile) {
    companyIdProofPhotoFile = newFile;
    notifyListeners();
  }

  updateBookingDate(value) {
    bookingDate = value;
    notifyListeners();
  }
  //------------------------FUNCTIONS--------------------------------------------------------------------------

  void clearLoadingPointFindLoad() {
    loadingPointCityFindLoad = "";
    loadingPointStateFindLoad = "";
    notifyListeners();
  }

  void clearUnloadingPointFindLoad() {
    unloadingPointCityFindLoad = "";
    unloadingPointStateFindLoad = "";
    notifyListeners();
  }

  void updateLoadingPointFindLoad(
      {required String city, required String state}) {
    loadingPointCityFindLoad = city;
    loadingPointStateFindLoad = state;
    notifyListeners();
  }

  void updateUnloadingPointFindLoad(
      {required String city, required String state}) {
    unloadingPointCityFindLoad = city;
    unloadingPointStateFindLoad = state;
    notifyListeners();
  }
  //////////////

  void clearLoadingPointPostLoad() {
    loadingPointCityPostLoad = "";
    loadingPointStatePostLoad = "";
    notifyListeners();
  }

  void clearUnloadingPointPostLoad() {
    unloadingPointCityPostLoad = "";
    unloadingPointStatePostLoad = "";
    notifyListeners();
  }

  void updateLoadingPointPostLoad(
      {required String city, required String state}) {
    loadingPointCityPostLoad = city;
    loadingPointStatePostLoad = state;
    notifyListeners();
  }

  void updateUnloadingPointPostLoad(
      {required String city, required String state}) {
    unloadingPointCityPostLoad = city;
    unloadingPointStatePostLoad = state;
    notifyListeners();
  }

  void updateIndex(int newValue) {
    index = newValue;
    notifyListeners();
  }

  //functions for login screen

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

  void updateProductType(value) {
    productType = value;
    notifyListeners();
  }

  //TODO: name change to something more relevant
  void clearAll() {
    inputControllerLengthCheck = false;
    buttonColor = MaterialStateProperty.all<Color>(Colors.grey);

    smsCode = '';
    notifyListeners();
  }
//-------------------------------------

  // functions for add truck pages

  void updateTruckTypeValue(value) {
    truckTypeValue = value;
    notifyListeners();
  }

  void updatePassingWeightValue(value) {
    passingWeightValue = value;
    notifyListeners();
  }

  void updateTotalTyresValue(value) {
    totalTyresValue = value;
    notifyListeners();
  }

  void updateTruckLengthValue(value) {
    truckLengthValue = value;
    notifyListeners();
  }

  void updateDriverDetailsValue(value) {
    driverIdValue = value;
    notifyListeners();
  }

  void updateTruckNumberValue(value) {
    truckNumberValue = value;
    notifyListeners();
  }

  void updateTruckNumber(value) {
    truckNumber = value;
    notifyListeners();
  }

  void updateTruckId(value) {
    truckId = value;
    notifyListeners();
  }

  void updateResetActive(bool value) {
    resetActive = value;
    notifyListeners();
  }

  void resetTruckFilters() {
    truckTypeValue = '';
    passingWeightValue = 0;
    totalTyresValue = 0;
    truckLengthValue = 0;
    driverIdValue = '';
    notifyListeners();
  }

  void resetPostLoadScreenOne() {
    clearLoadingPointPostLoad();
    clearUnloadingPointPostLoad();
    clearBookingDate();
    updateResetActive(false);
    notifyListeners();
  }

  void resetOnNewType() {
    passingWeightValue = 0;
    totalTyresValue = 0;
    truckLengthValue = 0;
    driverIdValue = '';
    notifyListeners();
  }

  void clearProductType() {
    productType = "";
    notifyListeners();
  }

  void clearBookingDate() {
    bookingDate = "";
    notifyListeners();
  }

  void resetTruckNumber() {
    truckNumberValue = '';
    notifyListeners();
  }

  void resetTruckNum() {
    truckNumber = 0;
    notifyListeners();
  }

  void updateDriverList(value) {
    driverList = value;
    notifyListeners();
  }

  bool postLoadScreenTwoButton() {
    if (truckNumber != 0 &&
        passingWeightValue != 0 &&
        truckTypeValue != '' &&
        productType != 'Choose Product Type') {
      return true;
    } else {
      return false;
    }
  }

  bool postLoadScreenOneButton() {
    if (loadingPointCityPostLoad != "" &&
        bookingDate != "" &&
        unloadingPointCityPostLoad != '') {
      return true;
    } else {
      return false;
    }
  }
//----------------------------------

}
