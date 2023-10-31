// import 'package:flutter/material.dart';
// import 'package:liveasy/constants/spaces.dart';
// import '../models/sarathiModel.dart';
//
// class SarathiScreen extends StatefulWidget {
//   final String userInput; //LICENCE NUMBER
//
//   const SarathiScreen({Key? key, required this.userInput}) : super(key: key);
//
//   @override
//   State<SarathiScreen> createState() => _SarathiScreenState();
// }
//
// class _SarathiScreenState extends State<SarathiScreen> {
//   final DLDetails dlDetails = DLDetails( //hardcoded response from the API
//     dlCovs: [
//       DLCOV(covdesc: "Transport Vehicle-M/HMV (Goods and Passenger)"),
//       DLCOV(covdesc: "LIGHT MOTOR VEHICLE"),
//       DLCOV(covdesc: "Motor Cycle with Gear(Non Transport)"),
//     ],
//     dlObj: DLObj(
//       dlLicno: "GJ04 20120005008",
//       dlStatus: "Active",
//       bioFullName: "MAHESHKUMAR GOHIL",
//       dlIssuedt: "2012-03-07",
//       dlNtValdtoDt: "2032-03-06",
//       dlNtValdfrDt: "2012-03-07",
//       omRtoFullname: "ARTO BOTAD",
//       dlRtoCode: "GJ33",
//     ),
//     bioImgObj: BioImgObj(
//       biPhoto: "https://imgs.search.brave.com/IAGvnPovOYFR_VF6eX2HdWRExCT2V5IQo7pj3Vn1AU8/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9zdDMu/ZGVwb3NpdHBob3Rv/cy5jb20vNjY3Mjg2/OC8xMzcwMS92LzYw/MC9kZXBvc2l0cGhv/dG9zXzEzNzAxNDEy/OC1zdG9jay1pbGx1/c3RyYXRpb24tdXNl/ci1wcm9maWxlLWlj/b24uanBn",
//     ),
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.userInput, style: TextStyle(color: Colors.black)),
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.network(
//                   'dlDetails.bioImgObj.biPhoto',
//                   width: 150,
//                   height: 150,
//                 ),
//                 Text("${dlDetails.dlObj?.dlStatus}"),
//                 SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: double.infinity,
//                     height: 1,
//                     color: Colors
//                         .grey[700], // Horizontal line to separate sections
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Padding(
//                   padding:
//                       EdgeInsets.fromLTRB(space_2, space_2, space_2, space_2),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("DL Holder Name: ",
//                                 style: TextStyle(fontSize: 16)),
//                             Text("${dlDetails.dlObj?.bioFullName}",
//                                 style: TextStyle(fontSize: 16)),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text("DL Issue On: ",
//                                 style: TextStyle(fontSize: 16)),
//                             Text("${dlDetails.dlObj?.dlIssuedt}",
//                                 style: TextStyle(fontSize: 16)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: double.infinity,
//                     height: 1,
//                     color: Colors.black, // Horizontal line to separate sections
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Padding(
//                   padding:
//                       EdgeInsets.fromLTRB(space_2, space_2, space_2, space_2),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("DL Valid Upto: ",
//                                 style: TextStyle(fontSize: 16)),
//                             Text("${dlDetails.dlObj?.dlNtValdtoDt}",
//                                 style: TextStyle(fontSize: 16)),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text("DL Valid From:",
//                                 style: TextStyle(fontSize: 16)),
//                             Text(" ${dlDetails.dlObj?.dlNtValdfrDt}",
//                                 style: TextStyle(fontSize: 16)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: double.infinity,
//                     height: 1,
//                     color: Colors
//                         .grey[700], // Horizontal line to separate sections
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       EdgeInsets.fromLTRB(space_2, space_2, space_2, space_2),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text("Vehicle class, Category",
//                         style: TextStyle(fontSize: 16)),
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     for (int i = 0; i < dlDetails.dlCovs!.length; i++)
//                       ListTile(
//                         title: Text("${i + 1}. ${dlDetails.dlCovs![i].covdesc}"),
//                       ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: double.infinity,
//                     height: 1,
//                     color: Colors
//                         .grey[700], // Horizontal line to separate sections
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                   EdgeInsets.fromLTRB(space_2, space_2, space_2, space_2),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Registration Authority ",
//                                 style: TextStyle(fontSize: 16)),
//                             Text("${dlDetails.dlObj?.omRtoFullname}",
//                                 style: TextStyle(fontSize: 16)),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text("RTO code",
//                                 style: TextStyle(fontSize: 16)),
//                             Text(" ${dlDetails.dlObj?.dlRtoCode}",
//                                 style: TextStyle(fontSize: 16)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
