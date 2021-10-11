import 'package:flutter/material.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/widgets/buttons/cancelButtonForAddNewDriver.dart';
import 'package:liveasy/widgets/buttons/okButtonDeleteDriver.dart';

class confirmDeleteDialogBox extends StatelessWidget {
  DriverModel driverData;

  confirmDeleteDialogBox({required this.driverData});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(space_6, space_7, space_6, space_4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius_2 - 2)),
      ),
      content: Text(
        'Are you sure? You want to delete this driver ',
        style: TextStyle(fontSize: size_8),
      ),
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.only(bottom: space_6),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          OkButtonDeleteDriver(driverData: driverData),
          CancelButtonForAddNewDriver()
        ])
      ],
    );
  }
}
