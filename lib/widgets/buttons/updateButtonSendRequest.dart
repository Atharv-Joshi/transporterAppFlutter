import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/deviceApiCalls.dart';
import 'package:liveasy/widgets/alertDialog/CompletedDialog.dart';
import '../../functions/putBookingApis.dart';
import '../../models/onGoingCardModel.dart';
import '../../screens/navigationScreen.dart';

//This button sends the apis request in the put booking apis
class UpdateButtonSendRequest extends StatefulWidget {
  String? truckId;
  int? selectedDeviceId;
  String? selectedDriverName;
  String? selectedDriverPhoneno;
  OngoingCardModel loadAllDataModel;

  UpdateButtonSendRequest({
    this.truckId,
    this.selectedDeviceId,
    this.selectedDriverName,
    this.selectedDriverPhoneno,
    required this.loadAllDataModel,
  });

  @override
  State<UpdateButtonSendRequest> createState() =>
      _UpdateButtonSendRequestState();
}

class _UpdateButtonSendRequestState extends State<UpdateButtonSendRequest> {
  Future<void> updateAndShowDialog() async {
    //For sim based tracking updating the unique ID with driver's phone number
    await DeviceApiCalls().UpdateUniqueId(
      truckId: widget.selectedDeviceId.toString(),
      uniqueId: widget.selectedDriverPhoneno!,
      truckName: widget.truckId!,
    );
    final apiResponse = await updateBooking(
      loadAllDataModel: widget.loadAllDataModel,
      truckId: widget.truckId,
      selectedDeviceId: widget.selectedDeviceId,
      selectedDriverName: widget.selectedDriverName,
      selectedDriverPhoneno: widget.selectedDriverPhoneno,
      bookingId: widget.loadAllDataModel.bookingId,
    );
    //After running put apis navigate to ongoingOrdersScreen
    Get.offAll(() => NavigationScreen());
    // Extract the "status" field from the API response
    String status =
        "Unknown"; // Default value in case the "status" field is not present
    try {
      final Map<String, dynamic> responseMap = json.decode(apiResponse);
      status = responseMap['status'] ?? status;
    } catch (e) {
      print("Failed to extract status from API response: $e");
    }

    // Show the extracted "status" in a new dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        const Duration dialogDisplayDuration = Duration(seconds: 3);
        Future<void>.delayed(dialogDisplayDuration, () {
          Navigator.of(context).pop();
        });
        return completedDialog(
          lowerDialogText: '',
          upperDialogText: status,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: space_10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkBlueColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(size_7), // Adjust the radius as needed
          ),
        ),
        child: Container(
            height: space_15,
            width: space_60,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Confirm Booking Details",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: size_10,
                  fontWeight: boldWeight,
                ),
              ),
            )),
        onPressed: updateAndShowDialog,
      ),
    );
  }
}
