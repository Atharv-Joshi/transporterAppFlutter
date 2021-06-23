import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable
class ShareButton extends StatefulWidget {
  String? loadingPointCity;

  ShareButton({this.loadingPointCity});

  @override
  _ShareButtonState createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  final screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        height: space_8,
        width: (space_10 * 2) + 6,
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(space_6),
            )),
            backgroundColor: MaterialStateProperty.all<Color>(liveasyGreen),
          ),
          onPressed: () async {
            final image = await screenshotController.captureFromWidget(Stack(
              children: [
                Container(
                  height: 10.0,
                  width: 10.0,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image(
                      image: AssetImage(
                        "assets/images/whatsAppImageBackground.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(widget.loadingPointCity.toString())
              ],
            ));
            saveAndShare(image);
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        fontSize: size_8,
                        fontWeight: normalWeight,
                        color: white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }
}
