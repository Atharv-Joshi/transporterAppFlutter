import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/screens/TransporterOrders/OrderApi/bookingApiCallsOrders.dart';
import 'package:liveasy/screens/TransporterOrders/OrderApi/loadOnGoingDeliveredDataOrders.dart';
import 'package:liveasy/screens/TransporterOrders/DeliveredScreenOrders/deliveredCardOrders.dart';
import 'package:liveasy/widgets/loadingWidget.dart';

class DeliveredScreenOrders extends StatelessWidget {
  final BookingApiCallsOrders bookingApiCallsOrders = BookingApiCallsOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.67,
        child: FutureBuilder(
          //getTruckData returns list of truck Model
          future: bookingApiCallsOrders.getDataByTransporterIdDelivered(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return LoadingWidget();
            }
            print('delivered snapshot length :' +
                '${snapshot.data.length}'); //number of cards

            if (snapshot.data.length == 0) {
              return Container(
                  margin: EdgeInsets.only(top: 153),
                  child: DeliveredCardOrders(
                    vehicleNo: "AB 23 45 2344",
                    productType: "medicine",
                    noOfTrucks: "3",
                    truckType: "Flatbed",
                    posterLocation: "Meerut",
                    posterName: "Uttkarsh",
                    companyApproved: true,
                    driverPhoneNum: "9234523421",
                    transporterPhoneNumber: "3245352435",
                    rate: 200,
                    loadingPoint: "meerut",
                    unloadingPoint: "delhi",
                    companyName: "ABC company",
                    truckNo: "234244",
                    driverName: "Raju",
                    startedOn: "23 may,2021",
                    endedOn: "27 may,2021",

                    // imei: snapshot.data['imei'],
                    // phoneNum: snapshot.data['phoneNum'],
                  ));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: loadAllDataOrders(snapshot.data[index]),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return SizedBox();
                          }
                          return DeliveredCardOrders(
                            vehicleNo: snapshot.data['truckNo'],
                            productType: snapshot.data['productType'],
                            noOfTrucks: snapshot.data['noOfTrucks'],
                            truckType: snapshot.data['truckType'],
                            posterLocation: snapshot.data['posterLocation'],
                            posterName: snapshot.data['posterName'],
                            companyApproved: snapshot.data['companyApproved'],
                            driverPhoneNum: snapshot.data['driverPhoneNum'],
                            transporterPhoneNumber:
                                snapshot.data['transporterPhoneNum'],
                            rate: snapshot.data['rate'],
                            loadingPoint: snapshot.data['loadingPoint'],
                            unloadingPoint: snapshot.data['unloadingPoint'],
                            companyName: snapshot.data['companyName'],
                            truckNo: snapshot.data['truckNo'],
                            driverName: snapshot.data['driverName'],
                            startedOn: snapshot.data['startedOn'],
                            endedOn: snapshot.data['endedOn'],

                            // imei: snapshot.data['imei'],
                            // phoneNum: snapshot.data['phoneNum'],
                          );
                        });
                  } //builder

                  );
            } //else
          },
        ));
  }
} //class end
