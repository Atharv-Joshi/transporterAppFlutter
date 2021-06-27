// import 'package:flutter/material.dart';
// import 'package:liveasy/functions/getDriverDetailsFromDriverId.dart';
// import 'package:liveasy/models/BookingModel.dart';
// import 'package:liveasy/models/loadApiModel.dart';
// import 'package:liveasy/models/loadPosterModel.dart';
// import 'package:liveasy/models/truckModel.dart';
// import 'package:liveasy/widgets/bookingCard.dart';
//
// import 'loadingWidget.dart';
//
// // ignore: must_be_immutable
// class GetBookingDriverDetails extends StatefulWidget {
//   BookingModel? bookingModel;
//   LoadApiModel? loadApiModel;
//   LoadPosterModel? loadPosterModel;
//   TruckModel? truckModel;
//
//   GetBookingDriverDetails(
//       {this.bookingModel,
//       this.loadApiModel,
//       this.loadPosterModel,
//       this.truckModel});
//
//   @override
//   _GetBookingDriverDetailsState createState() =>
//       _GetBookingDriverDetailsState();
// }
//
// class _GetBookingDriverDetailsState extends State<GetBookingDriverDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getDriverDetailsFromDriverId(widget.truckModel!.driverId),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.data == null) {
//             return Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.2),
//                 child: LoadingWidget());
//           }
//           return BookingCard(
//             bookingModel: widget.bookingModel,
//             loadApiModel: widget.loadApiModel,
//             loadPosterModel: widget.loadPosterModel,
//             truckModel: widget.truckModel,
//             driverModel: snapshot.data,
//           );
//         });
//   }
// }
