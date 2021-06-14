import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';

// ignore: must_be_immutable
class TruckCompanyName extends StatelessWidget {
  String companyName;
  TruckCompanyName({Key? key, required this.companyName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: size_3,
      ),
      child: Row(
        children: [
          Image(image: AssetImage("assets/images/truck.png")),
          SizedBox(
            width: 4,
          ),
          Text(
            companyName,
            style: TextStyle(
                fontWeight: mediumBoldWeight,
                fontSize: 14,
                color: veryDarkGrey,
                fontFamily: "Montserrat"),
          ),
        ],
      ),
    );
  }
}
