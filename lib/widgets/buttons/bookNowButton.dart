import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/myLoadPages/bookLoadScreen.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';

// ignore: must_be_immutable
class BookNowButton extends StatefulWidget {
  LoadDetailsScreenModel loadDetailsScreenModel;

  BookNowButton({required this.loadDetailsScreenModel});

  @override
  _BookNowButtonState createState() => _BookNowButtonState();
}

class _BookNowButtonState extends State<BookNowButton> {
  // List truckDetailsList = [];
  // List driverDetailsList = [];

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
        ? GestureDetector(
            onTap: () {
              if (transporterIdController.transporterApproved.value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashboardScreen(
                            selectedIndex: screens.indexOf(auctionScreen),
                            index: 1000,
                            visibleWidget: BookLoadScreen(
                              truckModelList: truckDetailsList,
                              driverModelList: driverDetailsList,
                              loadDetailsScreenModel:
                                  widget.loadDetailsScreenModel,
                              directBooking: true,
                            ))));
              } else {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => VerifyAccountNotifyAlertDialog(),
                );
              }
            },
            child: Container(
              height: space_6 + 1,
              width: space_16,
              decoration: BoxDecoration(
                  color: darkBlueColor,
                  borderRadius: BorderRadius.circular(radius_4)),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Image(
                      image: AssetImage('assets/icons/bookIcon.png'),
                    ),
                  ),
                  SizedBox(
                    width: space_1,
                  ),
                  Text(
                    'Book'.tr,
                    style: TextStyle(
                        color: white,
                        fontWeight: normalWeight,
                        fontSize: size_6 + 2),
                  ),
                ],
              ),
            ))
        : GestureDetector(
            onTap: () async {
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => transporterIdController
                        .transporterApproved.value
                    ? BookLoadScreen(
                        truckModelList: truckDetailsList,
                        driverModelList: driverDetailsList,
                        loadDetailsScreenModel: widget.loadDetailsScreenModel,
                        directBooking: true,
                      )
                    : VerifyAccountNotifyAlertDialog(),
              );
            },
            child: Container(
              height: space_8,
              width: (space_16 * 2) + 3,
              decoration: BoxDecoration(
                  color: darkBlueColor,
                  borderRadius: BorderRadius.circular(radius_6)),
              child: Center(
                child: Text(
                  'bookNow'.tr,
                  // AppLocalizations.of(context)!.bookNow,
                  style: TextStyle(
                      fontSize: size_8,
                      fontWeight: mediumBoldWeight,
                      color: white),
                ),
              ),
            ));
  }
}
