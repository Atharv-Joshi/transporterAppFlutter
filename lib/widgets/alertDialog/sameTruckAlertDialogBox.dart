import 'package:flutter/material.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/okButtonForSameTruck.dart';

class SameTruckAlertDialogBox extends StatelessWidget {
  const SameTruckAlertDialogBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Column(
          children: [
            Text('Truck number already exists'),
            Text('Enter a different truck number'),
            SizedBox(height: space_3),
            OkButtonForSameTruck(),
          ],
        ),
      ),
    );
  }
}
