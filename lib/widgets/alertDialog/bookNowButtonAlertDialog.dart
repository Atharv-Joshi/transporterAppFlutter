import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/getDriverNameFromDriverApi.dart';
import 'package:liveasy/functions/updateDriverIdInTruckApi.dart';
import 'package:liveasy/models/bidsModel.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/truckNumberRegistration.dart';
import 'package:liveasy/widgets/buttons/confirmButtonSendRequest.dart';
import 'package:liveasy/widgets/buttons/cancelButton.dart';
import 'package:provider/provider.dart';

import 'addDriverAlertDialog.dart';

// ignore: must_be_immutable
class BookNowButtonAlertDialog extends StatefulWidget {
  var truckDetailsList;
  var driverDetailsList;
  LoadDetailsScreenModel? loadDetailsScreenModel;
  BidsModel? bidsModel;
  bool? directBooking;

  BookNowButtonAlertDialog(
      {required this.truckDetailsList,
      required this.driverDetailsList,
      this.loadDetailsScreenModel,
      this.bidsModel,
      required this.directBooking});

  @override
  _BookNowButtonAlertDialogState createState() =>
      _BookNowButtonAlertDialogState();
}

class _BookNowButtonAlertDialogState extends State<BookNowButtonAlertDialog> {
  String? selectedTruckId;
  String? selectedTransporterId;
  String? selectedDriverId;
  String? selectedDriverDriverId;
  String tempDropDownValue2 = "";

  @override
  Widget build(BuildContext context) {
    var providerData = Provider.of<ProviderData>(context, listen: false);
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 3, right: 3, top: 3, bottom: 3),
      insetPadding: EdgeInsets.only(
        left: space_4,
        right: space_4,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select a Truck",
            style: TextStyle(fontSize: size_9, fontWeight: normalWeight),
          ),
          SizedBox(
            height: space_2,
          ),
          Container(
            height: space_7 + 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius_4 + 2),
                border: Border.all(color: darkGreyColor)),
            child: Padding(
              padding: EdgeInsets.only(
                left: space_2 - 2,
                right: space_2 - 2,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: providerData.dropDownValue1,
                  icon: Icon(Icons.arrow_drop_down_circle_sharp),
                  iconEnabledColor: darkBlueColor,
                  style: TextStyle(
                      fontSize: size_7,
                      fontWeight: regularWeight,
                      color: Colors.black),
                  onChanged: (String? newValue) {
                    if (newValue == "Add Truck") {
                      Get.to(() => AddNewTruck());
                    } else {
                      providerData.updateDropDownValue1(
                          newValue: newValue.toString());
                    }
                    searchingDetailsFromTruckNo();
                  },
                  items: providerData.truckNoList
                      .map<DropdownMenuItem<String>>((dynamic value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(
            height: space_2 + 2,
          ),
          Text(
            "Select a Driver",
            style: TextStyle(fontSize: size_9, fontWeight: normalWeight),
          ),
          SizedBox(
            height: space_2,
          ),
          Container(
            height: space_7 + 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius_4 + 2),
                border: Border.all(color: Color(0xFF878787))),
            child: Padding(
              padding: EdgeInsets.only(
                left: space_2 - 2,
                right: space_2 - 2,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: Provider.of<ProviderData>(context).dropDownValue2,
                  icon: Icon(Icons.arrow_drop_down_circle_sharp),
                  iconEnabledColor: darkBlueColor,
                  style: TextStyle(
                      fontSize: size_7,
                      fontWeight: regularWeight,
                      color: Colors.black),
                  onChanged: (String? newValue) {
                    if (newValue == "Add New Driver") {
                      showDialog(
                          context: context,
                          builder: (context) => AddDriverAlertDialog(selectedTruckId: selectedTruckId,));
                    } else {
                      providerData.updateDropDownValue2(
                          newValue: newValue.toString());
                    }
                    searchingDetailsFromDriverId();
                  },
                  items: providerData.driverNameList
                      .map<DropdownMenuItem<String>>((dynamic value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(top: space_11, bottom: space_4 + 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ConfirmButtonSendRequest(
                loadId: widget.loadDetailsScreenModel!.loadId.toString(),
                rate: widget.loadDetailsScreenModel!.rate.toString(),
                transporterId: selectedTransporterId,
                unit: widget.loadDetailsScreenModel!.unitValue,
                truckId: [selectedTruckId],
                postLoadId:
                    widget.loadDetailsScreenModel!.postLoadId.toString(),
                directBooking: widget.directBooking,
                bidsModel: widget.bidsModel,
                loadDetailsScreenModel: widget.loadDetailsScreenModel,
              ),
              CancelButton()
            ],
          ),
        )
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius_2 - 2)),
      ),
    );
  }

  searchingDetailsFromTruckNo() async {
    final truckList = widget.truckDetailsList;
    for (TruckModel item in truckList) {
      if (Provider.of<ProviderData>(context, listen: false)
              .dropDownValue1
              .toString()
              .compareTo(item.truckNo.toString()) ==
          0) {
        selectedTruckId = item.truckId.toString();
        selectedTransporterId = item.transporterId.toString();
        selectedDriverId = item.driverId.toString();
        tempDropDownValue2 =
            await getDriverNameFromDriverApi(context, item.driverId.toString());
        break;
      }
    }
  }

  searchingDetailsFromDriverId() async {
    final driverList = widget.driverDetailsList;
    for (DriverModel item in driverList) {
      if (Provider.of<ProviderData>(context, listen: false)
          .dropDownValue2
          .toString()
          .contains(item.phoneNum.toString())) {
        selectedDriverDriverId = item.driverId.toString();
        updateDriverIdInTruckApi(selectedTruckId, selectedDriverDriverId);
        break;
      }
    }
  }
}
