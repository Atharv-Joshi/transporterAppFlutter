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
import 'package:liveasy/functions/documentApi/getDocApiCallVerify.dart';
import 'package:liveasy/functions/documentApi/getDocumentApiCall.dart';

class docInputLr extends StatefulWidget {
  var providerData;
  String? bookingId;

  docInputLr({
    this.providerData,
    this.bookingId,
  });

  @override
  State<docInputLr> createState() => _docInputLrState();
}

class _docInputLrState extends State<docInputLr> {
  String? bookid;
  bool showUploadedDocs = true;
  bool verified = false;
  bool showAddMoreDoc = true;
  var jsonresponse;
  var docLinks = [];
  String? currentLang;
  PreviewUploadedImage previewUploadedImage = Get.put(PreviewUploadedImage());
  String addDocImageEng = "assets/images/uploadImage.png";
  String addDocImageHindi = "assets/images/uploadImage.png";
  String addDocImageEngMobile = "assets/images/AddDocumentImg.png";
  String addDocImageHindiMobile = "assets/images/AddDocumentImgHindi2.png";

  String addMoreDocImageEng = "assets/images/AddMoreDocImg.png";
  String addMoreDocImageHindi = "assets/images/AddMoreDocImgHindi.png";
//This function is used to get the documents from the document apis
  uploadedCheck() async {
    docLinks = [];
    docLinks = await getDocumentApiCall(bookid.toString(), "L");
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

  //This function is used to check whether the documents are verified or not
  verifiedCheck() async {
    jsonresponse = await getDocApiCallVerify(bookid.toString(), "L");

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
    currentLang = LocalizationService().getCurrentLocale().toString();

    if (currentLang == "hi_IN") {
      // to change the image selecting image according to the language.
      setState(() {
        addDocImageEng = addDocImageHindi;
        addMoreDocImageEng = addMoreDocImageHindi;
        addDocImageEngMobile = addDocImageHindiMobile;
      });
    }

    bookid = widget.bookingId.toString();
    uploadedCheck();
  }

  String? docType;

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
                      padding: EdgeInsets.only(
                          left: space_6, top: size_3, bottom: size_3),
                      child: Text(
                        "Upload Lorry Reciept".tr,
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
                    height: space_26,
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
                                      margin: EdgeInsets.only(
                                          right: size_2 - 1, top: size_2),
                                      height: space_26,
                                      width: space_34,
                                      child: verified
                                          ? const Image(
                                              image: AssetImage(
                                                  "assets/images/verifiedDoc.png")) // to show verified document image if uploaded doucments get verified.
                                          : docUploadbtn2(
                                              assetImage: addDocImageEngMobile,
                                              onPressed: () async {
                                                widget.providerData.LrPhotoFile !=
                                                        null
                                                    ? Get.to(ImageDisplay(
                                                        providerData: widget
                                                            .providerData
                                                            .LrPhotoFile,
                                                        imageName: 'LrPhoto64',
                                                      )) // naming image of Lorry Receipt in numeric order
                                                    : showUploadedDocs
                                                        ? showPickerDialog(
                                                            widget.providerData
                                                                .updateLrPhoto,
                                                            widget.providerData
                                                                .updateLrPhotoStr,
                                                            context)
                                                        : null;
                                              },
                                              imageFile: widget
                                                  .providerData.LrPhotoFile,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                        docLinks.length < 4
                            ? showAddMoreDoc
                                ? (widget.providerData.LrPhotoFile == null)
                                    ? Flexible(
                                        child: SizedBox(
                                          height: space_23,
                                          width: space_34,
                                          child: docUploadbtn2(
                                            assetImage: addMoreDocImageEng,
                                            onPressed: () async {
                                              if (widget.providerData
                                                      .LrPhotoFile ==
                                                  null) {
                                                showPickerDialog(
                                                    widget.providerData
                                                        .updateLrPhoto,
                                                    widget.providerData
                                                        .updateLrPhotoStr,
                                                    context);
                                              }
                                            },
                                            imageFile: null,
                                          ),
                                        ),
                                      )
                                    : Container()
                                : Container()
                            : Container()
                      ],
                    ),
                  )
                //The below code will be executed for Web
                : Card(
                    surfaceTintColor: transparent,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(space_2),
                      side: const BorderSide(
                          color: Color.fromRGBO(0, 0, 255, 0.27), width: 2.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(space_4),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Image(
                                  image:
                                      AssetImage("assets/icons/document.png")),
                              SizedBox(
                                width: space_3,
                              ),
                              const Text(
                                "Lorry Receipt",
                                style: TextStyle(
                                  fontSize: size_12,
                                  color: darkBlueColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: space_12,
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
                                    side: MaterialStateProperty.all(BorderSide(
                                        color: kLiveasyColor, width: size_1)),
                                  ),
                                  child: const Text(
                                    "View Lorry Receipt",
                                    style: TextStyle(color: kLiveasyColor),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: space_4,
                          ),
                          Row(
                            children: [
                              docLinks.isNotEmpty
                                  ? Container(
                                      color: whiteBackgroundColor,
                                      margin: EdgeInsets.only(
                                          right: size_2 - 1, top: size_2),
                                      height: space_6,
                                      width: space_11,
                                      child: Image(
                                        image: NetworkImage(
                                          "$proxyServer${docLinks[0].toString()}",
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                width: space_4,
                              ),
                              docLinks.length == 1
                                  ? Text(" 1 Images",
                                      style: TextStyle(
                                        fontSize: space_3,
                                      ))
                                  : docLinks.isNotEmpty
                                      ? Text("1+ Images ",
                                          style: TextStyle(
                                            fontSize: space_3,
                                          ))
                                      : const Text(" No Image"),
                              SizedBox(
                                width: space_14,
                              ),
                              GestureDetector(
                                  child: const Image(
                                      image: AssetImage(
                                          "assets/images/uploadImage.png")),
                                  onTap: () {
                                    if (widget.providerData.LrPhotoFile ==
                                        null) {
                                      showPickerDialog(
                                          widget.providerData.updateLrPhoto,
                                          widget.providerData.updateLrPhotoStr,
                                          context);
                                    } else {
                                      widget.providerData.LrPhotoFile != null
                                          ? Get.to(ImageDisplay(
                                              providerData: widget
                                                  .providerData.LrPhotoFile,
                                              imageName: 'LrPhoto64',
                                            ))
                                          : showUploadedDocs
                                              ? showPickerDialog(
                                                  widget.providerData
                                                      .updateLrPhoto,
                                                  widget.providerData
                                                      .updateLrPhotoStr,
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
                  width: space_48,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(space_4),
                        bottomLeft: Radius.circular(space_4)),
                    color: white,
                  ),
                  width: space_48,
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
