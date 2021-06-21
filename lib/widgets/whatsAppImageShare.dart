//
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
//
// // ignore: must_be_immutable
// class WhatsAppImageShare extends StatefulWidget {
//   String? loadingPointCity;
//
//   WhatsAppImageShare({this.loadingPointCity});
//
//   @override
//   _WhatsAppImageShareState createState() => _WhatsAppImageShareState();
// }
//
// class _WhatsAppImageShareState extends State<WhatsAppImageShare> {
//   ByteData? bytes;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       key: previewContainer,
//       child: Stack(
//         children: [
//           Container(
//             child: Image(
//               image: AssetImage(
//                 "assets/images/whatsAppImageBackground.png",
//               ),
//             ),
//           ),
//           Text(widget.loadingPointCity.toString())
//         ],
//       ),
//     );
//   }
//
// }
