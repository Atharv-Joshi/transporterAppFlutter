import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';

class imageDisplayUsingApi extends StatefulWidget {
  // const imageDisplayUsingApi({Key? key}) : super(key: key);
  String? docLink;
  imageDisplayUsingApi({this.docLink});

  @override
  State<imageDisplayUsingApi> createState() => _imageDisplayUsingApiState();
}

class _imageDisplayUsingApiState extends State<imageDisplayUsingApi> {
  bool progressBar = false;
  bool downloaded = false;
  bool downloading = false;

  void _saveNetworkImage(String path) async {
    // String path =
    //     'https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';
    GallerySaver.saveImage(path, albumName: "Liveasy").then((bool? success) {
      setState(() {
        print('Image is saved');
        progressBar = false;
        downloaded = true;
        downloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.fromLTRB(space_22, 0, 0, space_1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius_10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // clearImage(widget.imageName);
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.rectangle),
                        height: space_10,
                        width: space_10,
                        child: Center(
                          child: Icon(
                            Icons.clear,
                            color: darkBlueColor,
                            size: size_15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Flexible(
            // child:
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
                // Center(
                //   child: Container(
                //       margin: EdgeInsets.only(
                //           bottom: 5, left: 10, right: 10),
                //       padding:
                //           EdgeInsets.only(top: space_4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    child: Container(
                      color: Color.fromARGB(255, 20, 182, 88),
                      height: space_9,
                      // width: space_30,
                      child: Center(
                        child: progressBar
                            ? CircularProgressIndicator(
                                color: white,
                              )
                            : Text(
                                "Download Image".tr,
                                style: TextStyle(
                                    color: white,
                                    fontSize: size_8,
                                    fontWeight: FontWeight.bold),
                              ),
                        // ),
                      ),
                    ),
                    onTapUp: (value) {
                      setState(() {
                        progressBar = true;
                        downloading = true;
                      });
                    },
                    onTap: () {
                      _saveNetworkImage(widget.docLink.toString());
                    },
                  ),
                )),
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
                        widget.docLink.toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: activeButtonColor,
                  ),
                  child: Container(
                    height: space_8,
                    child: Center(
                      child: Text(
                        "Back".tr,
                        style: TextStyle(
                            color: white,
                            fontSize: size_8,
                            fontWeight: mediumBoldWeight),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
