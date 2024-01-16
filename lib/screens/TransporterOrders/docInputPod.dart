import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
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

// ignore: must_be_immutable
class docInputPod extends StatefulWidget {
  var providerData;
  String? bookingId;

  docInputPod({
    this.providerData,
    this.bookingId,
  });

  @override
  State<docInputPod> createState() => _docInputPodState();
}

class _docInputPodState extends State<docInputPod> {
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
  String addDocImageHindiMobile = "assets/images/AddDocumentImgHindi.png";

  String addMoreDocImageEng = "assets/images/AddMoreDocImg.png";
  String addMoreDocImageHindi = "assets/images/AddMoreDocImgHindi.png";

  //This function is used to get the documents from the document apis
  uploadedCheck() async {
    docLinks = [];
    docLinks = await getDocumentApiCall(bookid.toString(), "P");
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
    jsonresponse = await getDocApiCallVerify(bookid.toString(), "P");
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
    // TODO: implement initState
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
        height: Responsive.isMobile(context) ? screenHeight * 0.2 : 140,
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
                          const EdgeInsets.only(left: 30, top: 6, bottom: 6),
                      child: Text(
                        "Upload POD (Pahoch)".tr,
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
                                                            .PodPhotoFile !=
                                                        null
                                                    ? Get.to(ImageDisplay(
                                                        providerData: widget
                                                            .providerData
                                                            .PodPhotoFile,
                                                        imageName: 'PodPhoto64',
                                                      ))
                                                    : showUploadedDocs
                                                        ? showPickerDialog(
                                                            widget.providerData
                                                                .updatePodPhoto,
                                                            widget.providerData
                                                                .updatePodPhotoStr,
                                                            context)
                                                        : null;
                                              },
                                              imageFile: widget
                                                  .providerData.PodPhotoFile,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                        docLinks.length < 4
                            ? showAddMoreDoc
                                ? (widget.providerData.PodPhotoFile == null)
                                    ? Flexible(
                                        child: SizedBox(
                                          height: 116,
                                          width: 170,
                                          child: docUploadbtn2(
                                            assetImage: addMoreDocImageEng,
                                            onPressed: () async {
                                              if (widget.providerData
                                                      .PodPhotoFile ==
                                                  null) {
                                                showPickerDialog(
                                                    widget.providerData
                                                        .updatePodPhoto,
                                                    widget.providerData
                                                        .updatePodPhotoStr,
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
                      side: const BorderSide(
                          color: Color.fromRGBO(0, 0, 255, 0.27), width: 2.0),
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
                                "POD ",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: darkBlueColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                width: 140,
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
                                            color: Color(0xff000066),
                                            width: 2.0)),
                                  ),
                                  child: const Text(
                                    "View POD",
                                    style: TextStyle(color: Color(0xff000066)),
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
                                    if (widget.providerData.PodPhotoFile ==
                                        null) {
                                      showPickerDialog(
                                          widget.providerData.updatePodPhoto,
                                          widget.providerData.updatePodPhotoStr,
                                          context);
                                    } else {
                                      widget.providerData.PodPhotoFile != null
                                          ? Get.to(ImageDisplay(
                                              providerData: widget
                                                  .providerData.PodPhotoFile,
                                              imageName: 'PodPhoto64',
                                            ))
                                          : showUploadedDocs
                                              ? showPickerDialog(
                                                  widget.providerData
                                                      .updatePodPhoto,
                                                  widget.providerData
                                                      .updatePodPhotoStr,
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
            verified //to show the payment details after the pod documents are verified.
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, space_4, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Payment Details".tr,
                            style: TextStyle(
                                color: grey,
                                fontWeight: boldWeight,
                                fontSize: size_10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 10, right: 0, left: 0),
                        child: Divider(
                          height: size_1,
                          color: grey,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, space_4, 0, 0),
                            child: Text(
                              "Net earnings".tr,
                              style: TextStyle(
                                  color: black,
                                  fontWeight: mediumBoldWeight,
                                  fontSize: size_10),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, space_4, 0, 0),
                            child: Text(
                              "₹ 0",
                              style: TextStyle(
                                  color: black,
                                  fontWeight: boldWeight,
                                  fontSize: size_10),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, space_4, 0, 0),
                            child: Text(
                              "Net payment to passbook".tr,
                              style: TextStyle(
                                  color: black,
                                  fontWeight: mediumBoldWeight,
                                  fontSize: size_10),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, space_4, 0, 0),
                            child: Text(
                              "₹ 0",
                              style: TextStyle(
                                  color: black,
                                  fontWeight: boldWeight,
                                  fontSize: size_10),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, space_8, 0, 0),
                            child: Text(
                              "Total Net Balance".tr,
                              style: TextStyle(
                                  color: black,
                                  fontWeight: boldWeight,
                                  fontSize: size_10),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, space_8, 0, 0),
                            child: Text(
                              "₹ 0",
                              style: TextStyle(
                                  color: black,
                                  fontWeight: boldWeight,
                                  fontSize: size_10),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 14, bottom: 45, right: 0, left: 0),
                        child: Divider(
                          height: size_2,
                          color: grey,
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xff0077B6))),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 17, bottom: 17, right: 40, left: 40),
                            child: Text(
                              "Final Payment".tr,
                              style: TextStyle(
                                  color: white,
                                  fontWeight: boldWeight,
                                  fontSize: size_10),
                            ),
                          )),
                    ],
                  )
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
