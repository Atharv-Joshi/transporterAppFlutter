// import 'package:flutter/material.dart';
// import 'package:liveasy/constants/spaces.dart';
//
// import '../../screens/sarathiScreen.dart';
//
// class SarathiButton extends StatefulWidget {
//
//   const SarathiButton({Key? key}) : super(key: key);
//
//   @override
//   State<SarathiButton> createState() => _SarathiButtonState();
// }
//
// class _SarathiButtonState extends State<SarathiButton> {
//   TextEditingController _textEditingController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Padding(
//       padding: EdgeInsets.fromLTRB(space_2, space_0, space_2, space_0),
//       child: //Column(
//         //children: [
//           // TextField(
//           //   controller: _textEditingController,
//           //   decoration: InputDecoration(
//           //     hintText: "ENTER LICENCE NUMBER",
//           //     focusedBorder: OutlineInputBorder(
//           //       borderRadius: BorderRadius.circular(10),
//           //       borderSide: BorderSide(
//           //           color: Color(0xFF152968)), // Border color when focused
//           //     ),
//           //     enabledBorder: OutlineInputBorder(
//           //       borderRadius: BorderRadius.circular(10),
//           //     ),
//           //   ),
//           //   cursorColor: Color(0xFF152968),
//           // ),
//           ElevatedButton(
//             onPressed: () {
//               String userInput = _textEditingController.text;
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SarathiScreen(userInput: userInput )),
//               );
//             },
//             child: Text(
//               "SEARCH LICENCE",
//               style: TextStyle(color: Colors.white),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF152968),
//             ),
//           )
//         //],
//      // ),
//     ));
//   }
// }
