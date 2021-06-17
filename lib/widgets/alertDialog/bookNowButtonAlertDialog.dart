import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/raidus.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/getDriverNameFromDriverApi.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/truckNumberRegistration.dart';
import 'package:liveasy/widgets/buttons/confirmButtonSendRequest.dart';
import 'package:liveasy/widgets/buttons/cancelButton.dart';
import 'package:provider/provider.dart';

import 'addDriverAlertDialog.dart';

// String? _dropdownvalue1 = null;
// String? _dropdownvalue2 = null;

// ignore: must_be_immutable
class BookNowButtonAlertDialog extends StatefulWidget {
  // var truckNoList;
  var truckDetailsList;
  var driverDetailsList;

  String? loadId;

  BookNowButtonAlertDialog({
    // required this.truckNoList,
    required this.truckDetailsList,
    required this.driverDetailsList,
    required this.loadId,
  });

  @override
  _BookNowButtonAlertDialogState createState() =>
      _BookNowButtonAlertDialogState();
}

class _BookNowButtonAlertDialogState extends State<BookNowButtonAlertDialog> {
  String? selectedTruckId;
  String? selectedTransporterId;

  // String? selectedTruckNo;
  // String? selectedTruckApproved;
  // String? selectedImei;
  // String? selectedPassingWeight;
  String? selectedDriverId;

  // String? selectedTruckType;
  // String? selectedTyres;
  String? selected_Driver_DriverId;

  var temp_dropdownvalue2;

  // String? selected_Driver_TransporterId;
  // String? selected_Driver_PhoneNum;
  // String? selected_Driver_DriverName;
  // String? selected_Driver_TruckId;

  @override
  Widget build(BuildContext context) {
    var providerData = Provider.of<ProviderData>(context,listen: false);
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
                border: Border.all(color: borderLightColor)),
            child: Padding(
              padding: EdgeInsets.only(
                left: space_2 - 2,
                right: space_2 - 2,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: providerData.dropdownvalue1,
                  icon: Icon(Icons.arrow_drop_down_circle_sharp),
                  iconEnabledColor: darkBlueColor,
                  style: TextStyle(
                      fontSize: size_7,
                      fontWeight: regularWeight,
                      color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      newValue == "Add Truck"
                          ? Get.to(() => AddNewTruck())
                          : providerData.updateDropDownValue1(
                              newValue: newValue!);
                      searchingDetailsFromTruckNo();
                      providerData.updateDropDownValue2(
                          newValue: temp_dropdownvalue2.toString());
                    });
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
                  value: providerData.dropdownvalue2,
                  icon: Icon(Icons.arrow_drop_down_circle_sharp),
                  iconEnabledColor: darkBlueColor,
                  style: TextStyle(
                      fontSize: size_7,
                      fontWeight: regularWeight,
                      color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      newValue == "Add New Driver"
                          ? showDialog(
                              context: context,
                              builder: (context) => AddDriverAlertDialog())
                          : providerData.updateDropDownValue2(
                              newValue: newValue.toString());
                      searchingDetailsFromDriverId();
                    });
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
                loadId: widget.loadId,
                rate: "6000",
                transporterId: selectedTransporterId,
                unit: "perTon",
                truckId: [selectedTruckId],
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

  void searchingDetailsFromTruckNo() {
    final truckList = widget.truckDetailsList;
    for (TruckModel item in truckList) {
      if (Provider.of<ProviderData>(context)
              .dropdownvalue1!
              .compareTo(item.truckNo.toString()) ==
          0) {
        selectedTruckId = item.truckId.toString();
        selectedTransporterId = item.transporterId.toString();
        // widget.selectedTruckNo = item.truckNo.toString();
        // widget.selectedTruckApproved = item.truckId.toString();
        // widget.selectedImei = item.imei.toString();
        // widget.selectedPassingWeight = item.passingWeight.toString();
        selectedDriverId = item.driverId.toString();

        temp_dropdownvalue2 =
            getDriverNameFromDriverApi(item.driverId.toString());

        // widget.selectedTruckType = item.truckType.toString();
        // widget.selectedTyres = item.tyres.toString();
        break;
      }
    }
  }

  void searchingDetailsFromDriverId() {
    final driverList = widget.driverDetailsList;
    for (DriverModel item in driverList) {
      if (Provider.of<ProviderData>(context)
          .dropdownvalue2
          .toString()
          .contains(item.phoneNum.toString())) {
        selected_Driver_DriverId = item.driverId.toString();
        // widget.selected_Driver_TransporterId = item.transporterId.toString();
        // widget.selected_Driver_PhoneNum = item.phoneNum.toString();
        // widget.selected_Driver_DriverName = item.driverName.toString();
        // widget.selected_Driver_TruckId = item.truckId.toString();
        break;
      }
    }
  }
}
