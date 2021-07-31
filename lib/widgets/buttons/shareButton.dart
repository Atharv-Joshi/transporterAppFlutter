import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/shareImageWidget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

// ignore: must_be_immutable
class ShareButton extends StatelessWidget {
  LoadDetailsScreenModel loadDetails;
  String? loadingPointCity;
  ByteData? bytes;
  ScreenshotController screenshotController = ScreenshotController();
  ShareButton({this.loadingPointCity, required this.loadDetails});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print(
            "Loading Pint City is: ${loadDetails.loadingPointCity}"
                "\nUnloading Point City is: ${loadDetails.unloadingPointCity}"
                "\nLoading Point State is: ${loadDetails.loadingPointState}"
                "\nUnLoading Point State is: ${loadDetails.unloadingPointState}"
                "\nLoad Id is: ${loadDetails.loadId}"
        );
        screenshotController.captureFromWidget(
            InheritedTheme.captureAll(context, Material(child: shareImageWidget(loadDetails))),
            delay: Duration(seconds: 1)).then((capturedImage) async {
          var pngBytes = capturedImage.buffer.asUint8List();
          await WcFlutterShare.share(
              sharePopupTitle: 'share',
              subject: 'This is subject',
              text: "*🚛Aapke truck ke liye load uplabdh hai🚛*\nJaldi se iss load ko book karne ke liye iss link per click kare ya iss number per call kare ${loadDetails.phoneNo} \n*Aur load pane ke liye Liveasy app download kare*",
              fileName: 'share.png',
              mimeType: 'image/png',
              bytesOfFile: pngBytes
          );
        });
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
            )
          ],
        ),
      ),
    );
  }
}
