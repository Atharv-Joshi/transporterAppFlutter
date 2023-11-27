import 'package:flutter/material.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:get/get.dart';

import '../../models/onGoingCardModel.dart';
import '../../screens/updateBookingDetailsScreen.dart';

//this is the Button which is displayed in documentUploadScreen to update the truck and the driver details
class UpdateDriverTruckButton extends StatefulWidget {
  OngoingCardModel loadAllDataModel;

  UpdateDriverTruckButton({
    required this.loadAllDataModel,
  });

  @override
  _UpdateDriverTruckButtonState createState() =>
      _UpdateDriverTruckButtonState();
}

class _UpdateDriverTruckButtonState extends State<UpdateDriverTruckButton> {
  List<TruckModel> truckDetailsList = [];
  List<DriverModel> driverDetailsList = [];

  TruckApiCalls truckApiCalls = TruckApiCalls();
  DriverApiCalls driverApiCalls = DriverApiCalls();
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    truckDetailsList = await truckApiCalls.getTruckData();
    driverDetailsList = await driverApiCalls.getDriversByTransporterId();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
                transporterIdController.transporterApproved.value
                    ? UpdateBookingDetailsScreen(
                        truckModelList: truckDetailsList,
                        driverModelList: driverDetailsList,
                        loadAllDataModel: widget.loadAllDataModel,
                      )
                    : VerifyAccountNotifyAlertDialog(),
          );
        },
        child: Image.asset(
          'assets/icons/updateDriver.png',
          width: space_3 + 2,
          height: space_3 + 3,
        ));
  }
}
