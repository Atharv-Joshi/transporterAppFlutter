import 'package:flutter/cupertino.dart';

class ProviderData extends ChangeNotifier{
  int index = 0;

  void updateIndex(int newValue) {
    index = newValue;
    notifyListeners();
  }

}