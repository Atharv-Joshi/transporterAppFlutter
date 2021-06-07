import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/uploadRC.dart';
import 'package:liveasy/widgets/addTrucksHeader.dart';
import 'package:liveasy/widgets/applyButton.dart';


class AddNewTruck extends StatefulWidget {
  const AddNewTruck({Key? key}) : super(key: key);

  @override
  _AddNewTruckState createState() => _AddNewTruckState();
}

class _AddNewTruckState extends State<AddNewTruck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_4),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddTrucksHeader(),
              Text(
                  'Enter Truck Number',
                  style:  TextStyle(
                      fontSize: size_11,
                    color: truckGreen,
                  ),
              ),

              //TODO: center the hintext and apply shadows to textformfield
              Container(
                margin: EdgeInsets.symmetric(vertical : space_4),
                width: 179,
                height: 38,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Eg: UP 22 GK 2222',
                    hintStyle: TextStyle(
                        fontWeight: boldWeight,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: unselectedGrey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: unselectedGrey,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                child: ApplyButton(onPressedFunction: (){
                  Get.to(()=> UploadRCScreen());
                },),
                  // child: Container(
                  //   height: MediaQuery.of(context).size.height * 0.053,
                  //   width : MediaQuery.of(context).size.width * 0.3,
                  //   child: TextButton(
                  //     style: ButtonStyle(
                  //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(50),
                  //       )),
                  //       backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
                  //     ),
                  //     onPressed:(){
                  //       Get.to(()=> UploadRCScreen());
                  //     },
                  //     child: Text(
                  //       'Apply',
                  //       style: TextStyle(
                  //         letterSpacing: 0.7,
                  //         fontWeight: FontWeight.w400,
                  //         color: white,
                  //         fontSize: space_3,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.3,
                      MediaQuery.of(context).size.height * 0.62,
                      MediaQuery.of(context).size.width * 0.3,
                      0
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void applyButtonFunction(){
    Get.to(()=> UploadRCScreen() );
  }
}
