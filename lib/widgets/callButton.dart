import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/ChooseReceiverButton.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher ;
import 'package:url_launcher/link.dart';

class CallButton extends StatelessWidget {

   final String? phoneNum;

   final bool directCall;
  CallButton({this.phoneNum , required this.directCall});

  _makingPhoneCall() async {
    print('in makingPhoneCall');
    String url = 'tel:$phoneNum';
    UrlLauncher.launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      width: 80,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: darkBlueColor),
          )),
        ),
        onPressed: directCall == true
            ? (){
               _makingPhoneCall();
                }

          :()
      {
        Get.defaultDialog(
            radius: 10,
            title: 'Who do you want to call?',
            titleStyle: TextStyle(
              fontSize: size_8,
              color: loadingPointTextColor,
              fontWeight: mediumBoldWeight
            ),
            middleText: '',
            content: Center(
              child: Column(
                children: [
                  ChooseReceiverButton(label: 'D.K Transport', phoneNum: '1234567892' ,),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: space_2),
                    child: Text(
                        'or',
                        style: TextStyle(
                          fontSize: size_8,
                          fontWeight: mediumBoldWeight,
                          color: Colors.black
                        ),),
                  ),

                  ChooseReceiverButton(label: 'Ravi Shah', phoneNum: '6789056432',)

                ],
              ),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(left: space_1),
          child: Row(
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
                'Call',
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 0.7,
                  fontWeight: mediumBoldWeight,
                  color: Colors.black,
                  fontSize: size_7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
