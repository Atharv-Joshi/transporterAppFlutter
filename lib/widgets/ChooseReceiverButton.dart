import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ChooseReceiverButton extends StatelessWidget {
  final String? label;

  // final dynamic function ;
  final String? phoneNum;

  ChooseReceiverButton({required this.label, required this.phoneNum});

  _makingPhoneCall() async {
    print('in makingPhoneCall');
    String url = 'tel:$phoneNum';
    UrlLauncher.launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 163,
      height: 40,
      child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: darkBlueColor),
            )),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: space_1),
                child: Image(
                  height: 16,
                  width: 11,
                  image: AssetImage(
                    'assets/icons/callButtonIcon.png',
                  ),
                ),
              ),
              Text(
                label != null ? '$label' : 'NA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 0.7,
                  fontWeight: mediumBoldWeight,
                  color: bidBackground,
                  fontSize: size_8,
                ),
              ),
            ],
          ),
          onPressed: () {
            _makingPhoneCall();
          }),
    );
  }
}
