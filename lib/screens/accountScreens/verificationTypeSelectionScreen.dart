import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/accountScreens/accountVerificationPage1.dart';
import 'package:liveasy/screens/accountScreens/kycIDfyScreen.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:get/get.dart';
import '../../widgets/headingTextWidget.dart';

class VerificationTypeSelection extends StatelessWidget {
  const VerificationTypeSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(space_4, space_5, space_4, space_2),
            height: MediaQuery.of(context).size.height - space_4,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeadingTextWidget('Verification'), // 'Verification'
                    HelpButtonWidget(),
                  ],
                ),
                SizedBox(height: queryData.size.height/15,),
                Container(
                  alignment: Alignment.center,
                  width: queryData.size.width/1.2,
                  height: queryData.size.height/1.5,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.blueGrey,blurRadius: 5)],
                    gradient: LinearGradient(
                      stops: [0.5,0.5],
                      colors: [Color(0xFF152968),Colors.white],
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter,
                    ),
                  ),
                  //padding: EdgeInsets.only(left: 25,right: 25,top: 100,bottom: 20),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:EdgeInsets.only(top:queryData.size.height/15,),
                        child: Text('Verification of Transporter Status',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: space_3,
                          ),
                        ),
                      ),//Verification text title
                      Padding(
                        padding:EdgeInsets.only(top:3,),
                        child: Text('via Aadhaar',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: space_3,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top:queryData.size.height/12.5),
                        child: ElevatedButton(
                          onPressed: (){
                            Get.to(() => AccountVerificationPage1());
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor:Color(0xFF09B778),
                          ),
                          child: Text("Manual verification",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontSize: space_3,
                            ),
                          ),
                        ),
                      ),//Manual Verification Button
                      Padding(
                        padding: EdgeInsets.only(top: queryData.size.height/17.5),
                        child: Text('OR',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                offset:Offset(0, 2),
                                blurRadius: 3,
                                color: Colors.blueGrey,
                              )
                            ]
                          ),
                        ),
                      ), //Or text
                      Padding(
                        padding: EdgeInsets.only(top:queryData.size.height/11.3),
                        child: ElevatedButton(
                          onPressed: (){
                            Get.to(() => KYCIDfyScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor:Color(0xFF09B778),
                          ),
                          child: Text("Immediate verification",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontSize: space_3,
                            ),
                          ),
                        ),
                      ),//Immediate Verification Button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
