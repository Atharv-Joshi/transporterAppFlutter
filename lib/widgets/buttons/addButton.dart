import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/raidus.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddButton extends StatelessWidget {
  String displayContact;

  AddButton({required this.displayContact});

  @override
  Widget build(BuildContext context) {
    var providerData = Provider.of<ProviderData>(context);
    return GestureDetector(
      onTap: () {
        providerData.updateDriverNameList(newValue: displayContact);
        Navigator.of(context).pop();
      },
      child: Container(
        margin: EdgeInsets.only(right: space_3),
        height: space_6 + 1,
        width: space_16,
        decoration: BoxDecoration(
            color: bidBackground,
            borderRadius: BorderRadius.circular(radius_4)),
        child: Center(
          child: Text(
            "Add",
            style: TextStyle(
                color: white, fontWeight: normalWeight, fontSize: size_6 + 2),
          ),
        ),
      ),
    );
  }
}
