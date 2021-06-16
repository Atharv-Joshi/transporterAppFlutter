/*import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/raidus.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/getDriverDetailsFromDriverApi.dart';
import 'package:liveasy/models/driverModel.dart';

import 'addDriverAlertDialog.dart';

class DriverDropdown extends StatefulWidget {
  var driverDetailsList;
  String? selected_Driver_DriverId;
  String? selected_Driver_TransporterId;
  String? selected_Driver_PhoneNum;
  String? selected_Driver_DriverName;
  String? selected_Driver_TruckId;
  DriverDropdown({
    required this.driverDetailsList,
    this.selected_Driver_DriverId,
    this.selected_Driver_TransporterId,
    this.selected_Driver_PhoneNum,
    this.selected_Driver_DriverName,
    this.selected_Driver_TruckId,});

  @override
  _DriverDropdownState createState() => _DriverDropdownState();
}

class _DriverDropdownState extends State<DriverDropdown> {
  String? _dropdownvalue2 = null;
  @override
  Widget build(BuildContext context) {
    return Container(
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
            value: _dropdownvalue2,
            icon: Icon(Icons.arrow_drop_down_circle_sharp),
            iconEnabledColor: darkBlueColor,
            style: TextStyle(
                fontSize: size_7,
                fontWeight: regularWeight,
                color: Colors.black),
            onChanged: (String? newValue) {
              setState(() {
                newValue == "Add New Driver"
                    ? showInformationDialogAddDriver(context)
                    : _dropdownvalue2 = newValue!;
                searchingDetailsFromDriverId();
              });
            },
            items: driverNameList
                .map<DropdownMenuItem<String>>((dynamic value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  void searchingDetailsFromDriverId() {
    final driverList = widget.driverDetailsList;
    for (DriverModel item in driverList) {
      if (_dropdownvalue2.toString().contains(item.phoneNum.toString())) {
        widget.selected_Driver_DriverId = item.driverId.toString();
        widget.selected_Driver_TransporterId = item.transporterId.toString();
        widget.selected_Driver_PhoneNum = item.phoneNum.toString();
        widget.selected_Driver_DriverName = item.driverName.toString();
        widget.selected_Driver_TruckId = item.truckId.toString();
        print(item.truckId.toString());
        break;
      }
    }
  }
}*/
