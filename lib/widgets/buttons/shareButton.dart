import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:social_share/social_share.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

// ignore: must_be_immutable
class ShareButton extends StatelessWidget {
  String? loadingPointCity;
  ByteData? bytes;
  ShareButton({this.loadingPointCity});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
    // final ByteData bytes = await rootBundle.load('assets/image1.png');
    // await Share.file('esys image', 'esys.png', bytes.buffer.asUint8List(), 'image/png', text: 'My optional text.');

      onTap: () async {
        bytes = await rootBundle.load('assets/images/whatsAppImageBackground.png');
        await WcFlutterShare.share(
            sharePopupTitle: 'share',
            subject: 'This is subject',
            text: 'This is text',
            fileName: 'share.png',
            mimeType: 'image/png',
            bytesOfFile: bytes!.buffer.asUint8List());
        // SocialShare.shareWhatsapp(
        //     "Hello World"); //TODO: value has to be changed
      },
      child: Container(
        height: space_8,
        width: (space_10 * 2) + 6,
        decoration: BoxDecoration(
            color: liveasyGreen, borderRadius: BorderRadius.circular(space_6)),
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
            ),
            // Stack(children:[Container(
            //   child: Image(
            //     image: AssetImage(
            //       "assets/images/whatsAppImageBackground.png",
            //     ),
            //   ),
            // )])
          ],
        ),
      ),
    );
  }
}
