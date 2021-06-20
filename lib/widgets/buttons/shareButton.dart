import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:social_share/social_share.dart';

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SocialShare.shareWhatsapp(
            "Hello World"); //TODO: value has to be changed
      },
      child: Container(
        height: space_8,
        width: (space_10 * 2) + 6,
        decoration: BoxDecoration(
            color: liveasyGreen,
            borderRadius: BorderRadius.circular(space_6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: AssetImage("assets/icons/shareIcon.png"),
                height: size_9 - 1,
                width: size_9 - 1),
            SizedBox(
              width: space_1 - 0.5,
            ),
            Text(
              "Share",
              style: TextStyle(
                  fontSize: size_8, fontWeight: normalWeight, color: white),
            )
          ],
        ),
      ),
    );
  }
}
