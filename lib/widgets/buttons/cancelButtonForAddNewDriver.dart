import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CancelButtonForAddNewDriver extends StatefulWidget {





  @override
  _CancelButtonForAddNewDriverState createState() => _CancelButtonForAddNewDriverState();
}

class _CancelButtonForAddNewDriverState extends State<CancelButtonForAddNewDriver> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        margin: EdgeInsets.only(right: space_3),
        height: space_6 + 1,
        width: space_16,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: darkBlueColor)),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: TextStyle(
                color: Colors.black,
                fontWeight: normalWeight,
                fontSize: size_6 + 2),
          ),
        ),
      ),
    );
  }
}