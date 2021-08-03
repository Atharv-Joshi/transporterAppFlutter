import 'package:flutter/material.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/okButtonForSameTruck.dart';

class SameTruckAlertDialogBox extends StatelessWidget {
  const SameTruckAlertDialogBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(space_6, space_7, space_6, space_4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius_2 - 2)),
      ),
      content: Text(
        'Truck number already exists\nEnter a different truck number',
        style: TextStyle(fontSize: size_8),
      ),
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.only(bottom: space_6),
      actions: [OkButtonForSameTruck()],
    );
  }
}
