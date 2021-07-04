import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/screens/TransporterOrders/OrderApi/bookingApiCallsOrders.dart';
import 'package:liveasy/screens/TransporterOrders/OrderApi/loadOnGoingDeliveredDataOrders.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:liveasy/screens/TransporterOrders/OnGoingScreenOrders/onGoingCardOrder.dart';

class OngoingScreenOrders extends StatelessWidget {
  final BookingApiCallsOrders bookingApiCallsOrders = BookingApiCallsOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.67,
        child: FutureBuilder(
          //getTruckData returns list of truck Model
          future: bookingApiCallsOrders.getDataByTransporterIdOnGoing(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return LoadingWidget();
            }
            //number of cards

            if (snapshot.data.length == 0) {
              return Container(
                margin: EdgeInsets.only(top: 153),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage(
                          'assets/images/EmptyLoad.png'),
                      height: 127,
                      width: 127,
                    ),
                    Text(
                      'Looks like you have no on-going bookings!',
                      style: TextStyle(fontSize: size_8, color: grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: loadAllDataOrders(snapshot.data[index]),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return LoadingWidget();
                          }
                          return OngoingCardOrders(
                            loadingPoint: snapshot.data['loadingPoint'],
                            unloadingPoint: snapshot.data['unloadingPoint'],
                            companyName: snapshot.data['companyName'],
                            vehicleNo: snapshot.data['truckNo'],
                            driverName: snapshot.data['driverName'],
                            startedOn: snapshot.data['startedOn'],
                            bookingId: snapshot.data['bookingId'],
                            endedOn: snapshot.data['endedOn'],
                            imei: snapshot.data['imei'],
                            driverPhoneNum: snapshot.data['driverPhoneNum'],
                            transporterPhoneNumber:
                                snapshot.data['transporterPhoneNum'],
                            // transporterName : snapshot.data['transporterName'],
                          );
                        });
                  } //builder

                  );
            } //else
          },
        ));
  }
} //class end
