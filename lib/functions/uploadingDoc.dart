import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/previewUploadedImage.dart';

PreviewUploadedImage previewUploadedImage = Get.put(PreviewUploadedImage());
bool downloading = false;
Future<void> imageDownload(BuildContext context, var docLinks) {
  if (docLinks.isNotEmpty) {
    previewUploadedImage.updatePreviewImage(docLinks[0].toString());

    previewUploadedImage.updateIndex(0);
  }
  String proxyServer = dotenv.get('placeAutoCompleteProxy');

  //This basically shows a dialog box for viewing the uploaded images
  return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  " View Image",
                  style: TextStyle(
                    fontSize: size_10 - 1,
                    fontWeight: boldWeight,
                    color: darkBlueColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close,
                    color: darkBlueColor,
                  ),
                ),
              ),
              const Divider(
                height: 10,
              ),
            ],
          ),
          content: Column(
            children: [
              Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          int i = previewUploadedImage.index.value;
                          i = (i - 1) % docLinks.length as int;
                          previewUploadedImage
                              .updatePreviewImage(docLinks[i].toString());
                          previewUploadedImage.updateIndex(i);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: darkBlueColor,
                        ),
                      ),
                      docLinks.isNotEmpty
                          ? docLinks.length > 0
                              ? Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 100,
                                    width: 150,
                                    child: Image(
                                      image: NetworkImage(
                                        "$proxyServer${docLinks[0].toString()}",
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                          : Container(),
                      docLinks.isNotEmpty
                          ? docLinks.length > 1
                              ? Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 100,
                                    width: 150,
                                    child: Image(
                                      image: NetworkImage(
                                        "$proxyServer${docLinks[1].toString()}",
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                          : Container(),
                      docLinks.isNotEmpty
                          ? docLinks.length > 2
                              ? Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 100,
                                    width: 150,
                                    child: Image(
                                      image: NetworkImage(
                                        "$proxyServer${docLinks[2].toString()}",
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                          : Container(),
                      docLinks.isNotEmpty
                          ? docLinks.length > 3
                              ? Center(
                                  child: Container(
                                    color: whiteBackgroundColor,
                                    margin:
                                        const EdgeInsets.only(right: 3, top: 4),
                                    height: 100,
                                    width: 150,
                                    child: Image(
                                      image: NetworkImage(
                                        "$proxyServer${docLinks[3].toString()}",
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                          : Container(),
                      IconButton(
                        onPressed: () {
                          int i = previewUploadedImage.index.value;
                          i = (i + 1) % docLinks.length as int;
                          previewUploadedImage
                              .updatePreviewImage(docLinks[i].toString());
                          previewUploadedImage.updateIndex(i);
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: darkBlueColor,
                        ),
                      )
                    ],
                  )),
              Flexible(
                flex: 8,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(30),
                        height: 10,
                        width: 10,
                        child: const CircularProgressIndicator(
                          color: darkBlueColor,
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minHeight: 100),
                        color: whiteBackgroundColor,
                        child: Obx(() {
                          return Image.network(Uri.encodeFull(
                            "$proxyServer${previewUploadedImage.previewImage.toString()}",
                          ));
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, bottom: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          child: Container(
                            color: kLiveasyColor,
                            height: space_10,
                            child: Center(
                              child: downloading
                                  ? const CircularProgressIndicator(
                                      color: white,
                                    )
                                  : Text(
                                      "Download".tr,
                                      style: TextStyle(
                                        color: white,
                                        fontSize: size_8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          onTapUp: (value) {
                            downloading = true;
                          },
                          onTap: () async {
                            _saveNetworkImage(
                                "$proxyServer${previewUploadedImage.previewImage.toString()}");
                            downloading = false;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    SizedBox(
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          child: Container(
                            color: const Color(0xFFB6B6C1),
                            height: space_10,
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: const Color(0xFF000000),
                                  fontSize: size_8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        );
      });
}

//The below function is used to save the image or downnload the image onto your local storgae
void _saveNetworkImage(String path) async {
  await WebImageDownloader.downloadImageFromWeb(path,
      imageQuality: 0.5, name: "download");
}

//This function displays the image in smaller box
Future<void> uploadDoc(BuildContext context, var onPressed, var imageFile) {
  return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: GestureDetector(
            child: imageFile == null
                ? Center(
                    child: Image(
                        image: AssetImage("assets/images/uploadImage.png")),
                  )
                : Stack(
                    children: [
                      Center(
                          child: imageFile != null
                              ? Image(image: Image.file(imageFile).image)
                              : Container()),
                      Center(
                        child: imageFile == null
                            ? Center(
                                child: Container(),
                              )
                            : Center(
                                child: Text(
                                  "Tap to Open",
                                  style: TextStyle(
                                      fontSize: size_6, color: liveasyGreen),
                                ),
                              ),
                      ),
                    ],
                  ),
            onTap: onPressed,
          ),
        );
      });
}
