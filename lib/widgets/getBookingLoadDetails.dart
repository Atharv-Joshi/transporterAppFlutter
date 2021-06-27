// import 'package:flutter/material.dart';
// import 'package:liveasy/functions/getLoadDetailsFromLoadId.dart';
// import 'package:liveasy/models/BookingModel.dart';
// import 'package:liveasy/widgets/getCustomerDetails.dart';
//
// import 'loadingWidget.dart';
//
// // ignore: must_be_immutable
// class GetBookingLoadDetails extends StatefulWidget {
//   BookingModel? bookingModel;
//
//   GetBookingLoadDetails({this.bookingModel});
//
//   @override
//   _GetBookingLoadDetailsState createState() => _GetBookingLoadDetailsState();
// }
//
// class _GetBookingLoadDetailsState extends State<GetBookingLoadDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getLoadDetailsFromLoadId(widget.bookingModel!.loadId),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.data == null) {
//             return Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.2),
//                 child: LoadingWidget());
//           }
//           return GetCustomerDetails(
//               bookingModel: widget.bookingModel, loadApiModel: snapshot.data);
//         });
//   }
// }
