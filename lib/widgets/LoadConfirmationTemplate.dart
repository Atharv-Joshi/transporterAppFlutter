import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class LoadConfirmationTemplate extends StatelessWidget {
  final String? label;
  final String? value;
  LoadConfirmationTemplate({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: space_3),
      child: Container(
        margin: EdgeInsets.only(top: space_1),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$label',
                  style: TextStyle(fontWeight: normalWeight),
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          ":  ${value!}",
                          style: TextStyle(
                              fontWeight: mediumBoldWeight,
                              color: veryDarkGrey,
                              fontSize: size_6),
                        ),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: space_2,
            ),
            Divider(
              color: grey,
            )
          ],
        ),
      ),
    );
  }
}
