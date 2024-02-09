import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/screens.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/functions/truckApis/truckApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/responsive.dart';
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
    return (kIsWeb && Responsive.isDesktop(context))
    //Ui for Web
        ? GestureDetector(
            onTap: () {
              if (transporterIdController.transporterApproved.value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashboardScreen(
                            selectedIndex: screens.indexOf(ordersScreen),
                            index: 1000,
                            visibleWidget: UpdateBookingDetailsScreen(
                              truckModelList: truckDetailsList,
                              driverModelList: driverDetailsList,
                              loadAllDataModel: widget.loadAllDataModel,
                            ))));
              } else {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => VerifyAccountNotifyAlertDialog(),
                );
              }
            },
            child: Image.asset(
              'assets/icons/updateDriver.png',
              width: space_5,
              height: space_5,
            ))
    //Ui for mobile
        : GestureDetector(
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
              height: space_3 + 2,
            ));
  }
}
