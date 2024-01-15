import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';

class imageDisplayUsingApi extends StatefulWidget {
  // const imageDisplayUsingApi({Key? key}) : super(key: key);
  String? docLink;
  imageDisplayUsingApi({this.docLink});

  @override
  State<imageDisplayUsingApi> createState() => _imageDisplayUsingApiState();
}

class _imageDisplayUsingApiState extends State<imageDisplayUsingApi> {
  bool downloaded = false;
  bool downloading = false;
//This function is used to save or download the image on web or Mobile
  void _saveNetworkImage(String path) async {
    if (kIsWeb) {
      await WebImageDownloader.downloadImageFromWeb(path, imageQuality: 0.5);
    } else {
      var response = await Dio()
          .get(path, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "Liveasy");
    }
    setState(() {
      downloading = false;
      downloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    String proxyServer = dotenv.get('placeAutoCompleteProxy');
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: size_15 + 30,
              color: whiteBackgroundColor,
              child: Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: darkBlueColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: space_1,
                      ),
                      Text(
                        "Download Image".tr,
                        style: TextStyle(
                          fontSize: size_10 - 1,
                          fontWeight: boldWeight,
                          color: darkBlueColor,
                          // letterSpacing: -0.408
                        ),
                      ),
                    ],
                  ),
                  // ),
                ],
              ),
            ),
            Divider(
              height: size_3,
              color: darkGreyColor,
            ),
            downloading
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text("( Downloading.... )".tr),
                  )
                : Container(),
            downloaded
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text("( Downloaded )".tr),
                  )
                : Container(),
            Expanded(
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(30),
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: darkBlueColor,
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(minHeight: 100),
                      color: whiteBackgroundColor,
                      child: Image.network(
                          "$proxyServer${widget.docLink.toString()}"),
                    ),
                  ],
                ),
              ),
            ),
            Row(children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 7.5, bottom: 10, top: 10),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Color(0xFFE75347),
                      child: Container(
                        height: space_10,
                        child: Center(
                          child: Text(
                            "Cancel".tr,
                            style: TextStyle(
                                color: white,
                                fontSize: size_9,
                                fontWeight: mediumBoldWeight),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      }),
                ),
              ),
              Flexible(
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 7.5, right: 15, bottom: 10, top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        child: Container(
                          color: Color(0xFF09B778),
                          height: space_10,
                          child: Center(
                            child: downloading
                                ? CircularProgressIndicator(
                                    color: white,
                                  )
                                : Text(
                                    "Download".tr,
                                    style: TextStyle(
                                        color: white,
                                        fontSize: size_8,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                        onTapUp: (value) {
                          setState(() {
                            downloading = true;
                          });
                        },
                        onTap: () async {
                          _saveNetworkImage(
                              "$proxyServer${widget.docLink.toString()}");
                          downloading = false;
                        },
                      ),
                    )),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
