import 'dart:typed_data';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/WidgetLoadDetailsScreenModel.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/widgets/shareImageWidget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_config/flutter_config.dart';

// ignore: must_be_immutable
class DynamicLinkService extends StatefulWidget {
  
  int deviceId;
  String? truckId;
  String? truckNo;
  DynamicLinkService(
      {
      required this.deviceId,
       this.truckId,
       this.truckNo,
      });

  @override
  DynamicLink createState() => DynamicLink();
}

class DynamicLink extends State<DynamicLinkService> {
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
        link: Uri.parse('$shareUrl/track?deviceId=${widget.deviceId}&truckId=${widget.truckId}'),
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
      print("Dynamic URL is $url");
    }
 //   url = await parameters.buildUrl();
    print("Dynamic URL is $url");
    setState(() {
      _stringUrl = url.toString();
      _isCreateLink = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FloatingActionButton(
                            heroTag: "button2",
                            backgroundColor: bidBackground,
                            foregroundColor: Colors.white,
                            child: const Icon(Icons.share_outlined, size: 30),
                            onPressed: () 
                              async {
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
          await Share.share("To check the location of ${widget.truckNo},click on the link $_stringUrl",
                  
                  )
              .then((value) => EasyLoading.dismiss());
        },
                            
      ),
     
    );
    
  }
}