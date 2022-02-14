import 'dart:typed_data';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/WidgetLoadDetailsScreenModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/shareImageWidget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_config/flutter_config.dart';

// ignore: must_be_immutable
class ShareButton extends StatefulWidget {
  LoadDetailsScreenModel loadDetails;
  String? loadingPointCity;
  WidgetLoadDetailsScreenModel widgetLoadDetailsScreenModel;

  ShareButton(
      {this.loadingPointCity,
      required this.loadDetails,
      required this.widgetLoadDetailsScreenModel});

  @override
  _ShareButtonState createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  ByteData? bytes;

  bool _isCreateLink = false;

  String? _stringUrl;

  ScreenshotController screenshotController = ScreenshotController();

  Future<void> _createDynamicLink(bool short) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _isCreateLink = true;
    });
    String packageName = packageInfo.packageName;
    String shareUrl = FlutterConfig.get('shareUrl').toString();
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: shareUrl,
        link: Uri.parse('$shareUrl/${widget.loadDetails.loadId}'),
        androidParameters: AndroidParameters(
          packageName: packageName,
          minimumVersion: 0,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ));

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
      print("Dynamic URL is $url");
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _stringUrl = url.toString();
      _isCreateLink = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _createDynamicLink(true);
        EasyLoading.instance
          ..indicatorType = EasyLoadingIndicatorType.ring
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..maskColor = darkBlueColor
          ..userInteractions = false
          ..backgroundColor = darkBlueColor
          ..dismissOnTap = false;
        EasyLoading.show(
          status: "Loading...",
        );
        await screenshotController
            .captureFromWidget(InheritedTheme.captureAll(
                context, Material(child: shareImageWidget(widget.loadDetails))))
            .then((capturedImage) async {
          var pngBytes = capturedImage.buffer.asUint8List();
          await WcFlutterShare.share(
                  sharePopupTitle: 'share',
                  subject: 'This is subject',
                  text:
                      "*🚛Aapke truck ke liye load uplabdh hai🚛*\n\nJaldi se iss load ko book karne ke liye iss link per click kare👇🏻\n$_stringUrl\n\nya iss number per call kare ${widget.widgetLoadDetailsScreenModel.phoneNo} \n\n*Aur load pane ke liye Liveasy app download kare*",
                  fileName: 'share.png',
                  mimeType: 'image/png',
                  bytesOfFile: pngBytes)
              .then((value) => EasyLoading.dismiss());
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
                image: AssetImage("assets/icons/whatsappGreenIcon.png"),
                height: size_9 - 1,
                width: size_9 - 1),
            SizedBox(
              width: space_1 - 0.5,
            ),
            Text(
              'share'.tr,
              // AppLocalizations.of(context)!.share,
              style: TextStyle(
                  fontSize: size_8, fontWeight: normalWeight, color: white),
            )
          ],
        ),
      ),
    );
  }
}
