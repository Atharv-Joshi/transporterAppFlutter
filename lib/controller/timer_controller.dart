import 'dart:async';
import 'package:get/get.dart';

class TimerController extends GetxController {
  RxInt timeOnTimer = 60.obs;
  // late Timer timer = Timer(Duration(seconds: 0));
  Timer? timer;

  void startTimer() async {
    timeOnTimer = 60.obs;

    if(timer != null){
      cancelTimer();
    }
    

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeOnTimer > 0) {
        timeOnTimer--;
      } else {
        cancelTimer();
        // resendButtonColor = const Color(0xff109E92);
      }
    });
  }

  void cancelTimer() {
    timer!.cancel();
  }
}
