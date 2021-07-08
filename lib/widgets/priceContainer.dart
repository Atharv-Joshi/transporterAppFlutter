import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

// ignore: must_be_immutable
class PriceContainer extends StatelessWidget {
  String? rate;
  String? unitValue;

  PriceContainer({ required this.rate, required this.unitValue});

  @override
  Widget build(BuildContext context) {
    unitValue = unitValue == 'PER_TON' ? 'tonne' : 'truck';
    print(rate);
    print(rate.runtimeType);
    return
     Center(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 7),
              child: Image(
                height: 18,
                width: 18,
                image: AssetImage('assets/icons/creditCard.png'),
              ),
            ),
            Text(
              "\u20B9$rate/$unitValue",
              style: TextStyle(
                  color: darkBlueColor,
                  fontWeight: mediumBoldWeight,
                  ),
            ),
          ],
        ),
      );


  }
}
