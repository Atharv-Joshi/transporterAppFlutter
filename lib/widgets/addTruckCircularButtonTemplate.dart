import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';


class AddTruckCircularButtonTemplate extends StatelessWidget {

  final int text;
  final int value;

  bool selected = false;

  String category = '';

  int providerVariable = 0;
  dynamic providerFunction = (){};
  dynamic valueVariableFunction = (){};

  AddTruckCircularButtonTemplate({required this.value, required this.text , required this.category});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    if(category == 'weight'){
      providerVariable =  providerData.passingWeightButtonId;
      providerFunction =  providerData.updatePassingWeightButtonId;
      valueVariableFunction = providerData.updatePassingWeightValue;

    }
    else if(category == 'tyres'){
      providerVariable =  providerData.totalTyresButtonId;
      providerFunction =  providerData.updateTotalTyresButtonId;
      valueVariableFunction = providerData.updateTotalTyresValue;
    }
    else if(category == 'length'){
      providerVariable =  providerData.truckLengthButtonId;
      providerFunction =  providerData.updateTruckLengthButtonId;
      valueVariableFunction = providerData.updateTruckLengthValue;
    }

    // return Container(
    //   // width: 30,
    //   // height: 30,
    //   child: OutlinedButton(
    //     style: ButtonStyle(
    //         elevation: MaterialStateProperty.all<double>(2) ,
    //         backgroundColor:
    //         // providerData.passingWeightButtonId == value
    //         providerVariable == value
    //             ? MaterialStateProperty.all(darkBlueColor)
    //             : MaterialStateProperty.all(whiteBackgroundColor),
    //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //             RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(100),
    //             )
    //         )
    //     ),
    //     child: Text(
    //       '$text',
    //       style: TextStyle(
    //           fontSize: size_7,
    //           color: providerVariable == value ? white : black
    //       ),),
    //     onPressed: () {
    //       // providerData.updatePassingWeightButtonId(value);
    //       providerFunction(value);
    //       // setState(() {
    //       //   selected = true;
    //       //   truckTypeButtonController.updateButtonState(false);
    //       // });
    //     },
    //   ),
    // );

    return GestureDetector(
      child: Container(

        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: priceBackground ,offset: Offset.fromDirection(0.8) , spreadRadius: 1)],
          shape: BoxShape.circle,
          border: Border(
              top: BorderSide(width: 1 , color: grey),
              right: BorderSide(width: 1 , color: grey),
              left: BorderSide(width: 1 , color: grey),
              bottom: BorderSide(width: 1 , color: grey)
          ),
        ),
        child: CircleAvatar(
          backgroundColor: providerVariable == value
              ? darkBlueColor
              : whiteBackgroundColor,
          child: Text(
            '$text',
            style: TextStyle(
                fontSize: size_7,
                color: providerVariable == value ? white : black
            ),
          ),
        ),
      ),
      onTap: () {
        providerFunction(value);
        valueVariableFunction(value);
      },
    );

  }
}