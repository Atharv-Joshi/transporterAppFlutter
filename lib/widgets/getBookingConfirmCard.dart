// //TODO: pagination,decoration
// import 'package:flutter/material.dart';
// import 'package:liveasy/functions/getBookingConfirmFromBookingApi.dart';
// import 'package:liveasy/widgets/getBookingLoadDetails.dart';
//
// import 'loadingWidget.dart';
//
// class GetBookingConfirmCard extends StatefulWidget {
//   @override
//   _GetBookingConfirmCardState createState() => _GetBookingConfirmCardState();
// }
//
// class _GetBookingConfirmCardState extends State<GetBookingConfirmCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.67,
//       child: FutureBuilder(
//           future: getBookingConfirmFromBookingApi(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.data == null) {
//               return Container(
//                   padding: EdgeInsets.only(
//                       top: MediaQuery.of(context).size.height * 0.2),
//                   child: LoadingWidget());
//             }
//             // else if (snapshot.data.length == 0) {
//             //   return NoBidsWidget();
//             // }
//             return ListView.builder(
//               shrinkWrap: true,
//               padding: EdgeInsets.symmetric(),
//               itemCount: (snapshot.data.length),
//               itemBuilder: (BuildContext context, index) =>
//                   GetBookingLoadDetails(bookingModel: snapshot.data[index]),
//             );
//           }),
//     );
//   }
// }
