import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/backButtonWidget.dart';

class AddTrucksHeader extends StatelessWidget {
  const AddTrucksHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(

          children: [
            Container(
              margin: EdgeInsets.only(right: space_2),
                child: BackButtonWidget()),
            Text(
                'Add Truck',
                style : TextStyle(
                  fontSize: size_12,
                  fontWeight: mediumBoldWeight,
                )),
          ],
        ),
        TextButton(
            onPressed: (){
              print('reset button page');
            },
            child: Text(
                'Reset',
                style : TextStyle(
                  color: truckGreen,
                  fontSize: size_12,
                  fontWeight: regularWeight,
                )
            ))
      ],
    );
  }
}
