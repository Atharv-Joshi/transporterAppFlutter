import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/completedButton.dart';
import 'package:liveasy/widgets/buttons/trackButton.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/loadPosterDetails.dart';
import 'package:liveasy/widgets/newRowTemplate.dart';

class OnGoingLoadDetails extends StatelessWidget {

  final Map model;

  OnGoingLoadDetails({required this.model});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body :Container(
            margin: EdgeInsets.all(space_4),
            child: Column(
              children: [
                Header(reset: false, text: 'Order Details', backButton: true),
                Container(
                  margin: EdgeInsets.only(top: space_4),
                  child:                 Stack(
                    children: [
                      LoadPosterDetails(
                        loadPosterLocation: model['transporterLocation'],
                        loadPosterName:model['transporterName'],
                        loadPosterCompanyName: model['companyName'],
                        loadPosterCompanyApproved : model['transporterApproved'],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: space_8,
                            top: MediaQuery.of(context).size.height * 0.192,
                            right: space_8),
                        child: Container(
                          height: space_10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(radius_2 - 2)),
                          child: Card(
                            color: white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TrackButton(truckApproved: true,),
                                CallButton(
                                  directCall: false,
                                  driverPhoneNum:  model['driverPhoneNum'],
                                  driverName: model['driverName'],
                                  transporterPhoneNum: model['transporterPhoneNum'],
                                  transporterName:  model['transporterName'],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                Card(
                  elevation: 5,
                  child: Container(
                    margin: EdgeInsets.all(space_3),
                    child: Column(
                      children: [
                        NewRowTemplate(label: 'Location', value: '${model['loadingPoint']} - ${model['unloadingPoint']}'),
                        NewRowTemplate(label: 'Truck No', value: model['truckNo']),
                        NewRowTemplate(label: 'Truck Type', value: model['truckType']),
                        NewRowTemplate(label: 'No of Trucks', value: model['noOfTrucks']),
                        NewRowTemplate(label: 'Product Type', value: model['productType']),
                        NewRowTemplate(label: 'Price', value: '${model['rate']}/${model['unitValue']}'),
                      ],
                    ),
                  ),
                ),
                CompletedButtonOrders(bookingId: 'bookingId' , fontSize: size_7,)
              ],
            ),
          )
      ),
    );
  }
}
