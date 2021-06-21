import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/widgets/callButton.dart';
import 'package:liveasy/widgets/trackButton.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';

// ignore: must_be_immutable
class MyTruckCard extends StatefulWidget {

  // String? truckId;
  // String? transporterId;
  String? truckNo;
  bool truckApproved;
  // String? imei;
  // int? passingWeight;
  // String? driverId;
  String? truckType;
  int? tyres;
  String? driverName;
  String? phoneNum;

  MyTruckCard(
      {
        // this.truckId,
      // this.transporterId,
      this.truckNo,
      required this.truckApproved,
      // this.imei,
      // this.passingWeight,
      // this.driverId,
      this.truckType,
      this.driverName,
      this.phoneNum, // will be valid number or 'NA'
      this.tyres});

  @override
  _MyTruckCardState createState() => _MyTruckCardState();
}

class _MyTruckCardState extends State<MyTruckCard> {
  TruckFilterVariables truckFilterVariables = TruckFilterVariables();

  // DriverApiCalls driverApiCalls = DriverApiCalls();

  DriverModel driverModel = DriverModel();

  bool? verified  ;


  @override
  Widget build(BuildContext context) {

    widget.truckType = widget.truckType != null
        ? truckFilterVariables.truckTypeTextList[
            truckFilterVariables.truckTypeValueList.indexOf(widget.truckType)]
        : 'NA';

    Map<String, Color> statusColor = {
      'Available': liveasyGreen,
      'Busy': Colors.red,
      'Offline': unselectedGrey,
    };

    verified = widget.truckType != 'NA' || widget.tyres != null || widget.driverName != 'NA' || widget.phoneNum != "NA" ? true  : false;

    return Container(
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(space_3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, space_2, 0),
                    height: space_2,
                    width: space_2,
                    decoration: BoxDecoration(
                      color: statusColor['Offline'],
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  Text(
                    'Offline',
                    style: TextStyle(
                        fontWeight: mediumBoldWeight, fontSize: size_8),
                  ),
                ],
              ),

              verified!
                  ? Container(
                margin: EdgeInsets.symmetric(vertical: space_3),
                padding: EdgeInsets.only(right: space_8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //number and type column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle Number',
                          style: TextStyle(fontSize: size_6),
                        ),
                        Text(
                          '${widget.truckNo}',
                          style: TextStyle(
                              fontWeight: boldWeight, fontSize: size_7),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: space_3),
                          child: Text(
                            'Truck Type',
                            style: TextStyle(fontSize: size_6),
                          ),
                        ),
                        Text(
                          '${widget.truckType}',
                          style: TextStyle(
                              fontWeight: boldWeight, fontSize: size_7),
                        )
                      ],
                    ),
                    //tyre and driver column
                    Container(
                      // padding: EdgeInsets.only(left: space_14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tyre',
                            style: TextStyle(fontSize: size_6),
                          ),
                          Text(
                            widget.tyres != null ? '${widget.tyres}' : 'NA',
                            style: TextStyle(
                                fontWeight: boldWeight, fontSize: size_7),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: space_3),
                            child: Text(
                              'Driver',
                              style: TextStyle(fontSize: size_6),
                            ),
                          ),
                          Text(
                            '${widget.driverName}',
                            // 'Ravi Shah',
                            style: TextStyle(
                                fontWeight: boldWeight, fontSize: size_7),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
              : Container(
                margin: EdgeInsets.symmetric(vertical: space_3),
                padding: EdgeInsets.only(right: space_8),
                child:                     Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Number',
                      style: TextStyle(fontSize: size_6),
                    ),
                    Text(
                      '${widget.truckNo}',
                      style: TextStyle(
                          fontWeight: boldWeight, fontSize: size_7),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: space_3),
                      child: Text(
                        'Invalid Documents Uploaded !',
                        style: TextStyle(
                            fontSize: size_7,
                            fontWeight: boldWeight,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ) ,

              //track and call button
              verified! 
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
// <<<<<<< HEAD
//                     margin: EdgeInsets.only(right: space_2),
//                       child: TrackButton(truckApproved:truckApproved)
//                   ),
//                   //CallButton(), TODO: Check this Atharav
// =======
                      margin: EdgeInsets.only(right: space_2),
                      child: TrackButton(truckApproved: widget.truckApproved)),
                  CallButton(phoneNum: widget.phoneNum),
                ],
              )
              :
                Center(
                child: Container(
                  height: 32,
                  width: 201,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
                    ),
                    onPressed: (){print('Upload Truck Details Button Pressed');},
                    child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: space_2 , vertical: space_1),
                      child: Text(
                        'Upload Truck Details',
                        style: TextStyle(
                          letterSpacing: 0.7,
                          fontWeight: normalWeight,
                          color: white,
                          fontSize: size_7,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
