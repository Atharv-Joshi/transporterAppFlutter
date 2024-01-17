import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/previewUploadedImage.dart';
import 'package:liveasy/functions/uploadingDoc.dart';
import 'package:liveasy/language/localization_service.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/TransporterOrders/uploadedDocs.dart';
import '../../widgets/accountVerification/image_display.dart';
import 'docUploadBtn2.dart';
import 'dart:convert';
import 'dart:io';
import 'package:liveasy/widgets/alertDialog/permissionDialog.dart';
import 'dart:io' as Io;
import 'package:permission_handler/permission_handler.dart';
//import 'getDocApiCallVerify.dart';
//import 'getDocumentApiCall.dart';
import 'package:liveasy/functions/documentApi/getDocApiCallVerify.dart';
import 'package:liveasy/functions/documentApi/getDocumentApiCall.dart';

// ignore: must_be_immutable
class docInputWgtReceipt extends StatefulWidget {
  var providerData;
  String? bookingId;

  docInputWgtReceipt({
    this.providerData,
    this.bookingId,
  });

  @override
  State<docInputWgtReceipt> createState() => _docInputWgtReceiptState();
}

class _docInputWgtReceiptState extends State<docInputWgtReceipt> {
  String? bookid;
  bool showUploadedDocs = true;
  bool verified = false;
  bool showAddMoreDoc = true;
  var jsonresponse;
  var docLinks = [];
  PreviewUploadedImage previewUploadedImage = Get.put(PreviewUploadedImage());
  String? currentLang;
  String addDocImageEng = "assets/images/uploadImage.png";
  String addDocImageHindi = "assets/images/uploadImage.png";

  String addDocImageEngMobile = "assets/images/AddDocumentImg.png";
  String addDocImageHindiMobile = "assets/images/AddDocumentImgHindi.png";

  String addMoreDocImageEng = "assets/images/AddMoreDocImg.png";
  String addMoreDocImageHindi = "assets/images/AddMoreDocImgHindi.png";
//This function is used to get the documents from the document apis
  uploadedCheck() async {
    docLinks = [];
    docLinks = await getDocumentApiCall(bookid.toString(), "W");
    if (docLinks.isNotEmpty) {
      previewUploadedImage.updatePreviewImage(docLinks[0].toString());

      previewUploadedImage.updateIndex(0);
    }
    if (docLinks.isNotEmpty) {
      setState(() {
        showUploadedDocs = false;
      });
      if (docLinks.length == 4) {
        setState(() {
          showAddMoreDoc = false;
        });
      }
      verifiedCheck();
    }
  }

  //this function is used to check whether the documents are verified or not
  verifiedCheck() async {
    jsonresponse = await getDocApiCallVerify(bookid.toString(), "W");
    if (jsonresponse == true) {
      setState(() {
        verified = true;
      });
    } else {
      verified = false;
    }
  }

  @override
  void initState() {
    super.initState();
    bookid = widget.bookingId;
    currentLang = LocalizationService().getCurrentLocale().toString();

    if (currentLang == "hi_IN") {
      setState(() {
        addDocImageEng = addDocImageHindi;
        addMoreDocImageEng = addMoreDocImageHindi;
        addDocImageEngMobile = addDocImageHindiMobile;
      });
    }

    uploadedCheck();
  }

  @override
  Widget build(BuildContext context) {
    String proxyServer = dotenv.get('placeAutoCompleteProxy');
    double screenHeight = MediaQuery.of(context).size.height;
    return Material(
      child: SizedBox(
        height: Responsive.isMobile(context) ? screenHeight * 0.2 : space_28,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //The below code will be executed for Mobile
            Responsive.isMobile(context)
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    color: darkBlueColor,
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: space_6, top: 6, bottom: 6),
                      child: Text(
                        "Upload Weight Receipt".tr,
                        style: TextStyle(
                          color: white,
                          fontSize: size_7,
                        ),
                      ),
                    ),
                  )
                : Container(),
            //The below code will be executed for Mobile
            Responsive.isMobile(context)
                ? SizedBox(
                    height: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        !showUploadedDocs
                            ? Flexible(
                                flex: 2,
                                child: uploadedDocs(
                                  docLinks: docLinks,
                                  verified: verified,
                                ),
                              )
                            : Flexible(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 130,
                                      width: 170,
                                      child: verified
                                          ? const Image(
                                              image: AssetImage(
                                                  "assets/images/verifiedDoc.png"))
                                          : docUploadbtn2(
                                              assetImage: addDocImageEngMobile,
                                              onPressed: () async {
                                                widget.providerData
                                                            .WeightReceiptPhotoFile !=
                                                        null
                                                    ? Get.to(ImageDisplay(
                                                        providerData: widget
                                                            .providerData
                                                            .WeightReceiptPhotoFile,
                                                        imageName:
                                                            'WeightReceiptPhoto64',
                                                      ))
                                                    : showUploadedDocs
                                                        ? showPickerDialog(
                                                            widget.providerData
                                                                .updateWeightReceiptPhoto,
                                                            widget.providerData
                                                                .updateWeightReceiptPhotoStr,
                                                            context)
                                                        : null;
                                              },
                                              imageFile: widget.providerData
                                                  .WeightReceiptPhotoFile,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                        docLinks.length < 4
                            ? showAddMoreDoc
                                ? (widget.providerData.WeightReceiptPhotoFile ==
                                        null)
                                    ? Flexible(
                                        child: SizedBox(
                                          height: 116,
                                          width: 170,
                                          child: docUploadbtn2(
                                            assetImage: addMoreDocImageEng,
                                            onPressed: () async {
                                              if (widget.providerData
                                                      .WeightReceiptPhotoFile ==
                                                  null) {
                                                showPickerDialog(
                                                    widget.providerData
                                                        .updateWeightReceiptPhoto,
                                                    widget.providerData
                                                        .updateWeightReceiptPhotoStr,
                                                    context);
                                              }
                                            },
                                            imageFile: null,
                                          ),
                                        ),
                                      )
                                    : Container()
                                : Container()
                            : Container(),
                      ],
                    ),
                  )
                //The below code will be executed for Web
                : Card(
                    surfaceTintColor: transparent,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: borderblue, width: 2.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Image(
                                  image:
                                      AssetImage("assets/icons/document.png")),
                              const SizedBox(
                                width: 15,
                              ),
                              const Text(
                                "Weight Receipt",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: darkBlueColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              ElevatedButton(
                                  onPressed: docLinks.isNotEmpty
                                      ? () {
                                          imageDownload(context, docLinks);
                                        }
                                      : null,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(white),
                                    side: MaterialStateProperty.all(
                                        const BorderSide(
                                            color: kLiveasyColor, width: 2.0)),
                                  ),
                                  child: const Text(
                                    "View Weight Receipt",
                                    style: TextStyle(color: kLiveasyColor),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              docLinks.isNotEmpty
                                  ? Container(
                                      color: whiteBackgroundColor,
                                      margin: const EdgeInsets.only(
                                          right: 3, top: 4),
                                      height: 30,
                                      width: 55,
                                      child: Image(
                                        image: NetworkImage(
                                          "$proxyServer${docLinks[0].toString()}",
                                        ),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(
                                width: 20,
                              ),
                              docLinks.length == 1
                                  ? const Text(" 1 Images",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ))
                                  : docLinks.isNotEmpty
                                      ? const Text("1+ Images ",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ))
                                      : const Text(" No Image"),
                              const SizedBox(
                                width: 70,
                              ),
                              GestureDetector(
                                  child: const Image(
                                      image: AssetImage(
                                          "assets/images/uploadImage.png")),
                                  onTap: () {
                                    if (widget.providerData
                                            .WeightReceiptPhotoFile ==
                                        null) {
                                      showPickerDialog(
                                          widget.providerData
                                              .updateWeightReceiptPhoto,
                                          widget.providerData
                                              .updateWeightReceiptPhotoStr,
                                          context);
                                    } else {
                                      widget.providerData
                                                  .WeightReceiptPhotoFile !=
                                              null
                                          ? Get.to(ImageDisplay(
                                              providerData: widget.providerData
                                                  .WeightReceiptPhotoFile,
                                              imageName: 'WeightReceiptPhoto64',
                                            ))
                                          : showUploadedDocs
                                              ? showPickerDialog(
                                                  widget.providerData
                                                      .updateWeightReceiptPhoto,
                                                  widget.providerData
                                                      .updateWeightReceiptPhotoStr,
                                                  context)
                                              : null;
                                    }
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
            docLinks.isNotEmpty
                ? Responsive.isMobile(context)
                    ? Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "( Uploaded )".tr,
                          style: const TextStyle(color: black),
                        ),
                      )
                    : Container()
                : Container(),
          ],
        ),
      ),
    );
  }

  //To show picker dialog to select document upload from Gallery or Camera
  showPickerDialog(var functionToUpdate, var strToUpdate, var context) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            child: Wrap(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    color: white,
                  ),
                  width: 240,
                  child: ListTile(
                      textColor: black,
                      iconColor: black,
                      leading: const Icon(Icons.photo_library),
                      title: Text("Gallery".tr),
                      onTap: () async {
                        await getImageFromGallery2(
                            functionToUpdate, strToUpdate, context);
                        Navigator.of(context).pop();
                      }),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: white,
                  ),
                  width: 240,
                  child: ListTile(
                    textColor: black,
                    iconColor: black,
                    leading: const Icon(Icons.photo_camera),
                    title: Text("Camera".tr),
                    onTap: () async {
                      await getImageFromCamera2(
                          functionToUpdate, strToUpdate, context);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

//The below funtion is used to get the documents or images from camera
  Future getImageFromCamera2(
      var functionToUpdate, var strToUpdate, var context) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      if (await Permission.camera.request().isGranted) {
        final picker = ImagePicker();
        var pickedFile = await picker.pickImage(source: ImageSource.camera);
        final bytes = await Io.File(pickedFile!.path).readAsBytes();
        String img64 = base64Encode(bytes);
        functionToUpdate(File(pickedFile.path));
        strToUpdate(img64);
        setState(() {});
      } else {
        showDialog(context: context, builder: (context) => PermissionDialog());
      }
    } else {
      final picker;
      var pickedFile;
      final bytes;

      picker = ImagePicker();
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      bytes = await Io.File(pickedFile!.path).readAsBytes();
      String img64 = base64Encode(bytes);
      print("Base64 is $img64");
      functionToUpdate(File(pickedFile.path));
      strToUpdate(img64);
      setState(() {});
    }
  }

//The below funtion is used to get the documents or images from gallery
  Future getImageFromGallery2(
      var functionToUpdate, var strToUpdate, var context) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      if (await Permission.camera.request().isGranted) {
        final picker = ImagePicker();
        var pickedFile = await picker.pickImage(source: ImageSource.gallery);
        final bytes = await Io.File(pickedFile!.path).readAsBytes();
        String img64 = base64Encode(bytes);
        functionToUpdate(File(pickedFile.path));
        strToUpdate(img64);
      } else {
        showDialog(context: context, builder: (context) => PermissionDialog());
      }
    } else {
      final picker;
      var pickedFile;
      final bytes;

      picker = ImagePicker();
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      bytes = kIsWeb
          ? await pickedFile.readAsBytes()
          : await Io.File(pickedFile!.path).readAsBytes();
      String img64 = base64Encode(bytes);
      functionToUpdate(File(pickedFile.path));
      strToUpdate(img64);
      setState(() {});
    }
  }
}
