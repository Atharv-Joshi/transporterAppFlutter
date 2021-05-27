import 'package:flutter/cupertino.dart';

class ProviderData extends ChangeNotifier {
  int index = 0;
  String loadingPointCity = "";
  String loadingPointState = "";

  String unloadingPointCity = "";
  String unloadingPointState = "";

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
}
