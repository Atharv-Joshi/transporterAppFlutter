import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class LoadEndPointTemplate extends StatelessWidget {

  final String? endPointType;
   String? text;

  LoadEndPointTemplate({required this.text, required this.endPointType});

  @override
  Widget build(BuildContext context) {
    if(text!.length > 15){
      text = text!.substring(0 , 14) + '..';
    }
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: space_1),
          child: Image(
              height: 10,
              width: 10,
              image: endPointType == 'loading'
                  ? AssetImage('assets/icons/greenFilledCircleIcon.png')
                  : AssetImage('assets/icons/redSemiFilledCircleIcon.png')),
        ),
        Text(
          '$text',
          style: TextStyle(
            color: liveasyBlackColor,
            fontWeight: mediumBoldWeight,
            fontSize: size_9,
          ),
        ),
      ],
    );
  }
}
