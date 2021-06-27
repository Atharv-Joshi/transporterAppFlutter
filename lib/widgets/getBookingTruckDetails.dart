// import 'package:flutter/material.dart';
// import 'package:liveasy/functions/getTruckDetailsFromTruckId.dart';
// import 'package:liveasy/models/BookingModel.dart';
// import 'package:liveasy/models/loadApiModel.dart';
// import 'package:liveasy/models/loadPosterModel.dart';
//
// import 'getBookingDriverDetails.dart';
// import 'loadingWidget.dart';
//
// // ignore: must_be_immutable
// class GetBookingTruckDetails extends StatefulWidget {
//   BookingModel? bookingModel;
//   LoadApiModel? loadApiModel;
//   LoadPosterModel? loadPosterModel;
//
//   GetBookingTruckDetails(
//       {this.bookingModel, this.loadApiModel, this.loadPosterModel});
//
//   @override
//   _GetBookingTruckDetailsState createState() => _GetBookingTruckDetailsState();
// }
//
// class _GetBookingTruckDetailsState extends State<GetBookingTruckDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getTruckDetailsFromTruckId(widget.bookingModel!.truckId),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.data == null) {
//             return Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.2),
//                 child: LoadingWidget());
//           }
//           return GetBookingDriverDetails(
//             bookingModel: widget.bookingModel,
//             loadApiModel: widget.loadApiModel,
//             loadPosterModel: widget.loadPosterModel,
//             truckModel: snapshot.data,
//           );
//         });
//   }
// }
