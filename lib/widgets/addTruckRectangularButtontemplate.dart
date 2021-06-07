import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';


class AddTruckRectangularButtonTemplate extends StatelessWidget {

  final String text;
  final String value;
  bool selected = false;

  AddTruckRectangularButtonTemplate({required this.value, required this.text});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      child: OutlinedButton(
        style: ButtonStyle(
            backgroundColor:
            providerData.truckTypeButtonId == value
                ? MaterialStateProperty.all(darkBlueColor)
                : MaterialStateProperty.all(whiteBackgroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                )
            )
        ),
        child: Text(
          '$text',
          style: TextStyle(
              fontSize: size_7,
              color: providerData.truckTypeButtonId == value ? white : black
          ),),
        onPressed: () {
          providerData.updateTruckTypeButtonId(value);
          // setState(() {
          //   selected = true;
          //   truckTypeButtonController.updateButtonState(false);
          // });
        },
      ),
    );
  }
}
