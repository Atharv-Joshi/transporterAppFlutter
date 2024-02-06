import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/alertOkButton.dart';
//Alert box for showing tracking is not available on that device
class AlertDialogBox extends StatelessWidget {
  String dialog;
  AlertDialogBox({Key? key, required this.dialog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Adding a delay of 3 seconds before automatically closing the dialog
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
    });

    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height / 3.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage("assets/images/alert.png"),
              width: space_10,
              height: space_10,
            ),
            SizedBox(height: space_4),
            Text(
              dialog,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: normalWeight,
                fontSize: size_8,
                color: red,
              ),
            ),
            SizedBox(height: space_3),
          ],
        ),
      ),
    );
  }
}
