// import 'package:flutter/material.dart';
// import 'package:liveasy/constants/fontSize.dart';
// import 'package:liveasy/constants/fontWeights.dart';
// class CallButton extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 31,
//       width: 80,
//       decoration: BoxDecoration(
//           border: Border.all(color: Color.fromRGBO(21, 41, 104, 1)),
//           borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.call,
//             ),
//             Text(
//               "Call",
//               style: TextStyle(
//                   fontSize: size_6 + 1, fontWeight: mediumBoldWeight),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class CallButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      width: 80,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: darkBlueColor),
          )),
        ),
        onPressed: (){print('Call Button Pressed');},
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: space_1),
              child: Icon(
                Icons.call,
                size: 20,
                color: black ,
              ),
            ),
            Text(
              'Call',
              style: TextStyle(
                letterSpacing: 0.7,
                fontWeight: mediumBoldWeight,
                color: Colors.black,
                fontSize: space_3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}