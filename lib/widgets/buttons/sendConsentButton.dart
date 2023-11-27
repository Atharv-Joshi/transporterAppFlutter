import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/elevation.dart';
import 'package:liveasy/widgets/alertDialog/CompletedDialog.dart';
import '../../constants/spaces.dart';
import '../../functions/consentAPIs.dart';

//This button is used to send the consent to the user
class SendConsentButton extends StatefulWidget {
  String? mobileno;
  String? selectedOperator;
  String? responseStatus;
  SendConsentButton({
    required this.mobileno,
    required this.selectedOperator,
  });
  @override
  State<SendConsentButton> createState() => _SendConsentButtonState();
}

class _SendConsentButtonState extends State<SendConsentButton> {
  String? responseStatus; // Store the response status

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkBlueColor,
          elevation: elevation_0,
        ),
        onPressed: () async {
          final response = await consentApiCall(
            mobileNumber: widget.mobileno,
            operator: widget.selectedOperator,
          );
          // Check the response status
          responseStatus = response['status'];

          // Show dialog based on the response status
          _showDialogBasedOnStatus(responseStatus);
        },
        child: Row(
          children: [
            Image.asset(
              'assets/icons/rightArrow.png',
              width: 13,
              height: 13,
            ),
            Padding(
              padding: EdgeInsets.only(left: space_2),
              child: Text('Send Consent'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialogBasedOnStatus(String? status) {
    if (status == "Consent Send to driver") {
      // Show dialog 1 for "consent send to the driver"
      showDialog(
        context: context,
        builder: (BuildContext context) {
          const Duration dialogDisplayDuration = Duration(seconds: 3);
          Future<void>.delayed(dialogDisplayDuration, () {
            Navigator.of(context).pop();
          });
          return completedDialog(
            lowerDialogText: '',
            upperDialogText: 'Consent has been sent to the driver.',
          );
        },
      );
    } else if (status == "Device already registered") {
      // Show dialog 2 for "device already registered"
      showDialog(
        context: context,
        builder: (BuildContext context) {
          const Duration dialogDisplayDuration = Duration(seconds: 3);
          Future<void>.delayed(dialogDisplayDuration, () {
            Navigator.of(context).pop();
          });
          return completedDialog(
            lowerDialogText: '',
            upperDialogText: 'The device is already registered.',
          );
        },
      );
    } else {
      // Show a generic dialog for other cases
      showDialog(
        context: context,
        builder: (BuildContext context) {
          const Duration dialogDisplayDuration = Duration(seconds: 3);
          Future<void>.delayed(dialogDisplayDuration, () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            title: Text(
              "Response Status",
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  Image(
                    image: AssetImage("assets/images/alert.png"),
                    width: space_10,
                    height: space_10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: space_2),
                    child: Text(
                        status ?? "Something went wrong please try again!!"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
