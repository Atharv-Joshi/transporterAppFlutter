import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/Web/dashboard.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/screens.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/consentStatus.dart';
import 'package:liveasy/functions/loadOnGoingData.dart';
import 'package:liveasy/functions/loadOperatorInfo.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/TransporterOrders/docInputEWBill.dart';
import 'package:liveasy/screens/TransporterOrders/docInputLr.dart';
import 'package:liveasy/screens/TransporterOrders/docInputPod.dart';
import 'package:liveasy/screens/TransporterOrders/docInputWgtReceipt.dart';
import 'package:liveasy/screens/fastagScreen.dart';
import 'package:liveasy/widgets/buttons/sendConsentButton.dart';
import 'package:liveasy/widgets/buttons/updateDriver&TruckButton.dart';
import 'package:liveasy/widgets/gpsbutton.dart';
import 'package:liveasy/widgets/simTrackingButton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/models/onGoingCardModel.dart';
import 'package:liveasy/widgets/buttons/vahanButton.dart';
import 'package:liveasy/functions/documentApi/getDocName.dart';
import 'package:liveasy/functions/documentApi/getDocumentApiCall.dart';
import 'package:liveasy/functions/documentApi/postDocumentApiCall.dart';
import 'package:liveasy/functions/documentApi/putDocumentApiCall.dart';

//This screen code is executed for Document upload screen for web
// ignore: must_be_immutable
class documentUploadScreenWeb extends StatefulWidget {
  String? bookingId;
  String? loadId;
  String? bookingDate;
  String? truckNo;
  String? transporterName;
  String? transporterPhoneNum;
  String? driverName;
  String? driverPhoneNum;
  String? loadingPoint;
  String? unloadingPoint;
  var gpsDataList;
  String? totalDistance;
  var device;
  OngoingCardModel loadAllDataModel;
  LoadDetailsScreenModel? loadDetailsScreenModel;

  documentUploadScreenWeb(
      {Key? key,
      this.bookingId,
      this.loadId,
      this.bookingDate,
      this.truckNo,
      this.transporterName,
      this.transporterPhoneNum,
      this.driverName,
      this.driverPhoneNum,
      this.unloadingPoint,
      this.loadingPoint,
      this.gpsDataList,
      this.totalDistance,
      this.device,
      required this.loadAllDataModel,
      this.loadDetailsScreenModel})
      : super(key: key);

  @override
  _documentUploadScreenWebState createState() =>
      _documentUploadScreenWebState();
}

class _documentUploadScreenWebState extends State<documentUploadScreenWeb> {
  bool progressBar = false;
  // bool? pod1 = false;
  // bool podother = false;
  String status = 'Pending'; // Default status
  String? selectedOperator;
  List<String> operatorOptions = [
    'Airtel',
    'Vodafone',
    'Jio',
  ];
  Map? loadData;
  final StatusAPI statusAPI = StatusAPI();
  @override
  void initState() {
    super.initState();
    // pod1 = false;
    fetchConsent();
    fetchDataFromLoadApi();
    loadOperatorInfo(widget.driverPhoneNum, updateSelectedOperator);
    Permission.camera.request();
  }

  //This function is used to fetch the load Details
  fetchDataFromLoadApi() async {
    Map ongoingloadData =
        await loadApiCalls.getDataByLoadId(widget.loadAllDataModel.loadId!);
    setState(() {
      loadData = ongoingloadData;
    });
  }

  //This function is used to fetch the operator info select it by default from the dropdown
  void updateSelectedOperator(String newOperator) {
    setState(() {
      selectedOperator = newOperator;
    });
  }

  //This function is used to fetch the consent status
  Future<void> fetchConsent() async {
    final responseStatus = await statusAPI.getStatus(widget.driverPhoneNum!);

    setState(() {
      status = responseStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = Responsive.isMobile(context);
    Get.put(TransporterIdController());
    var providerData = Provider.of<ProviderData>(context);

    //Pod :-

    late Map
        datanew; // this map will contain the data to be posted using the post document api.
    datanew = {
      "entityId": widget.bookingId.toString(),
      "documents": [
        {}
        // {"documentType": "documentType", "data": }
      ],
    };
    late Map dataput;
    // bool verified = false;

    // function to call the post or put api functions according to the need to upload the documents.
    uploadDocumentApiCall() async {
      var response = await postDocumentApiCall(datanew);
      if (response == "put") {
        dataput = {"documents": datanew["documents"]};
        response =
            await putDocumentApiCall(dataput, widget.bookingId.toString());
      }
      if (response == "successful") {
        // after uploading the document successfully we null the provider data of the documents to stop displaying the document upload screen.
        setState(() {
          providerData.PodPhotoFile = null;
          providerData.PodPhoto64 = null;
          providerData.LrPhotoFile = null;
          providerData.LrPhoto64 = null;
          providerData.EwayBillPhotoFile = null;
          providerData.EwayBillPhoto64 = null;
          providerData.WeightReceiptPhotoFile = null;
          providerData.WeightReceiptPhoto64 = null;
          progressBar = false;
        });
      }
      // return response;
    }

    var jsonresponse;
    var docLinks = [];
    var availDocs = [];

    mapAvaildataPod(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {"documentType": docname, "data": providerData.PodPhoto64};

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    assignDocNamePod(int i) async {
      // for assigning the document name according the available document name.
      if (i == 0) {
        await mapAvaildataPod(i, "PodPhoto1");
      } else if (i == 1) {
        await mapAvaildataPod(i, "PodPhoto2");
      } else if (i == 2) {
        await mapAvaildataPod(i, "PodPhoto3");
      } else if (i == 3) {
        await mapAvaildataPod(i, "PodPhoto4");
      }
    }

    //for uploading the POD
    uploadFirstPod() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {"documentType": "PodPhoto1", "data": providerData.PodPhoto64}
        ],
      };
      await uploadDocumentApiCall();
    }

    uploadedCheckPod() async {
      // to check already uploaded pod documents .
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "P");
      setState(() {
        docLinks = docLinks;
      });
      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "P");

          setState(() {
            availDocs = availDocs;
          });
          await assignDocNamePod(availDocs[0]);
          providerData.PodPhotoFile = null;
          providerData.PodPhoto64 = null;
        }
        // verifiedCheckPod();
      } else {
        await uploadFirstPod();
      }
    }

    //this function is used to map the available Lr data
    mapAvaildataLr(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {"documentType": docname, "data": providerData.LrPhoto64};

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    assignDocNameLr(int i) async {
      if (i == 0) {
        await mapAvaildataLr(i, "LrPhoto1");
      } else if (i == 1) {
        await mapAvaildataLr(i, "LrPhoto2");
      } else if (i == 2) {
        await mapAvaildataLr(i, "LrPhoto3");
      } else if (i == 3) {
        await mapAvaildataLr(i, "LrPhoto4");
      }
    }

    //This is used to upload the Lr
    uploadFirstLr() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {"documentType": "LrPhoto1", "data": providerData.LrPhoto64}
        ],
      };
      // providerData.Lr = false;
      await uploadDocumentApiCall();
    }

    //This is used to get the Lr data
    uploadedCheckLr() async {
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "L");
      setState(() {
        docLinks = docLinks;
      });
      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
          // setState(() {
          //   showAddMoreDoc = false;
          // });
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "L");

          setState(() {
            availDocs = availDocs;
          });
          await assignDocNameLr(availDocs[0]);
          // await uploadDocumentApiCall();
          providerData.LrPhotoFile = null;
          providerData.LrPhoto64 = null;
        }
        // verifiedCheckLr();
      } else {
        await uploadFirstLr();
      }
    }

    //for mapping the Eway Bill data
    mapAvaildataEwayBill(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {
          "documentType": docname,
          "data": providerData.EwayBillPhoto64
        };

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    //Assigning names to the Eway-Bills
    assignDocNameEwayBill(int i) async {
      if (i == 0) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto1");
      } else if (i == 1) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto2");
      } else if (i == 2) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto3");
      } else if (i == 3) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto4");
      }
    }

    //Uploading the Eway Bill
    uploadFirstEwayBill() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {
            "documentType": "EwayBillPhoto1",
            "data": providerData.EwayBillPhoto64
          }
        ],
      };
      await uploadDocumentApiCall();
    }

    //Get the E-way Bills
    uploadedCheckEwayBill() async {
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "E");
      setState(() {
        docLinks = docLinks;
      });
      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "E");

          setState(() {
            availDocs = availDocs;
          });
          await assignDocNameEwayBill(availDocs[0]);
          providerData.EwayBillPhotoFile = null;
          providerData.EwayBillPhoto64 = null;
        }
        // verifiedCheckEwayBill();
      } else {
        await uploadFirstEwayBill();
      }
    }

    //Mapping the available weight receipt
    mapAvaildataWeightReceipt(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {
          "documentType": docname,
          "data": providerData.WeightReceiptPhoto64
        };

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    //Assigning name to the documents
    assignDocNameWeightReceipt(int i) async {
      if (i == 0) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto1");
      } else if (i == 1) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto2");
      } else if (i == 2) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto3");
      } else if (i == 3) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto4");
      }
    }

    //Uploading the Weight Receipt
    uploadFirstWeightReceipt() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {
            "documentType": "WeightReceiptPhoto1",
            "data": providerData.WeightReceiptPhoto64
          }
        ],
      };
      await uploadDocumentApiCall();
    }

    //The below code is used for managing the string length
    String wrapWords(String input, int maxChars) {
      List<String> words = input.split(' ');
      List<String> lines = [];
      String currentLine = '';

      for (String word in words) {
        if ((currentLine.length + word.length) <= maxChars) {
          currentLine += '$word ';
        } else {
          lines.add(currentLine.trim());
          currentLine = '$word ';
        }
      }

      lines.add(currentLine.trim());
      return lines.join('\n');
    }

    String formatLoadingPoint(String loadingPoint) {
      if (loadingPoint.length > 150) {
        return loadingPoint.substring(0, 150) + '...';
      } else if (loadingPoint.length > 10) {
        return loadingPoint.replaceAllMapped(
            RegExp(r"(.{1,40})(?:\s|$)"), (match) => "${match.group(1)}\n");
      } else {
        return loadingPoint;
      }
    }

    String formatText(String text) {
      if (text.length > 30) {
        return text.substring(0, 30) + '...';
      } else {
        return text;
      }
    }

    //Uploading the Weight Receipt
    uploadedCheckWeightReceipt() async {
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "W");
      setState(() {
        docLinks = docLinks;
      });
      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "W");

          setState(() {
            availDocs = availDocs;
          });
          await assignDocNameWeightReceipt(availDocs[0]);
          // await uploadDocumentApiCall();
          providerData.WeightReceiptPhotoFile = null;
          providerData.WeightReceiptPhoto64 = null;
        }
        // verifiedCheckWeightReceipt();
      } else {
        await uploadFirstWeightReceipt();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        // to null the provider data of the documents variables after clicking the back button of the android device.

        // var providerData = Provider.of<ProviderData>(context);
        providerData.LrPhotoFile = null;
        providerData.LrPhoto64 = null;

        providerData.EwayBillPhotoFile = null;
        providerData.EwayBillPhoto64 = null;

        providerData.WeightReceiptPhotoFile = null;
        providerData.WeightReceiptPhoto64 = null;

        providerData.PodPhotoFile = null;
        providerData.PodPhoto64 = null;
        return true;
      },
      child: Scaffold(
        backgroundColor: docScreenColor,
        body: Container(
          child: (providerData.LrPhotoFile !=
                  null) // to display the document upload screen only if the lr photo is selected by the user.
              ? SafeArea(
                  child: Scaffold(
                    body: Column(
                      children: [
                        Container(
                          height: size_15 + 30,
                          color: whiteBackgroundColor,
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Get.back();
                                          setState(() {
                                            providerData.LrPhotoFile = null;
                                            providerData.LrPhoto64 = null;

                                            providerData.EwayBillPhotoFile =
                                                null;
                                            providerData.EwayBillPhoto64 = null;

                                            providerData
                                                .WeightReceiptPhotoFile = null;
                                            providerData.WeightReceiptPhoto64 =
                                                null;

                                            providerData.PodPhotoFile = null;
                                            providerData.PodPhoto64 = null;
                                          });
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
                                      "Upload Image".tr,
                                      style: TextStyle(
                                          fontSize: size_10 - 1,
                                          fontWeight: boldWeight,
                                          color: darkBlueColor,
                                          letterSpacing: -0.408),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: size_3,
                          color: darkGreyColor,
                        ),
                        providerData.LrPhotoFile != null
                            ? Expanded(
                                child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, left: 10, right: 10),
                                    child: kIsWeb
                                        ? Image.network(
                                            providerData.LrPhotoFile!.path)
                                        : Image.file(providerData.LrPhotoFile!),
                                  ),
                                ),
                              )
                            : Container(),
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
                                        "Discard".tr,
                                        style: TextStyle(
                                            color: white,
                                            fontSize: size_9,
                                            fontWeight: mediumBoldWeight),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      providerData.LrPhotoFile = null;
                                    });
                                    providerData.LrPhotoFile = null;
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
                                          child: progressBar
                                              ? CircularProgressIndicator(
                                                  color: white,
                                                )
                                              : Text(
                                                  "Save".tr,
                                                  style: TextStyle(
                                                      color: white,
                                                      fontSize: size_9,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        ),
                                      ),
                                      onTapUp: (value) {
                                        setState(() {
                                          progressBar = true;
                                        });
                                      },
                                      onTap: uploadedCheckLr),
                                )),
                          ),
                        ]),
                      ],
                    ),
                  ),
                )
              : (providerData.EwayBillPhotoFile != null)
                  ? SafeArea(
                      child: Scaffold(
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: size_15 + 30,
                                color: whiteBackgroundColor,
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Get.back();
                                                setState(() {
                                                  providerData.LrPhotoFile =
                                                      null;
                                                  providerData.LrPhoto64 = null;

                                                  providerData
                                                      .EwayBillPhotoFile = null;
                                                  providerData.EwayBillPhoto64 =
                                                      null;

                                                  providerData
                                                          .WeightReceiptPhotoFile =
                                                      null;
                                                  providerData
                                                          .WeightReceiptPhoto64 =
                                                      null;

                                                  providerData.PodPhotoFile =
                                                      null;
                                                  providerData.PodPhoto64 =
                                                      null;
                                                });
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
                                            "Upload Image".tr,
                                            style: TextStyle(
                                                fontSize: size_10 - 1,
                                                fontWeight: boldWeight,
                                                color: darkBlueColor,
                                                letterSpacing: -0.408),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: size_3,
                                color: darkGreyColor,
                              ),
                              providerData.EwayBillPhotoFile != null
                                  ? Expanded(
                                      child: SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 10, right: 10),
                                          child: kIsWeb
                                              ? Image.network(providerData
                                                  .EwayBillPhotoFile!.path)
                                              : Image.file(providerData
                                                  .EwayBillPhotoFile!),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Row(children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 7.5,
                                        bottom: 10,
                                        top: 10),
                                    child: MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        color: Color(0xFFE75347),
                                        child: Container(
                                          height: space_10,
                                          child: Center(
                                            child: Text(
                                              "Discard".tr,
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: size_9,
                                                  fontWeight: mediumBoldWeight),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            providerData.EwayBillPhotoFile =
                                                null;
                                          });
                                          providerData.EwayBillPhotoFile = null;
                                        }),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 7.5,
                                          right: 15,
                                          bottom: 10,
                                          top: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: InkWell(
                                            child: Container(
                                              color: Color(0xFF09B778),
                                              height: space_10,
                                              child: Center(
                                                child: progressBar
                                                    ? CircularProgressIndicator(
                                                        color: white,
                                                      )
                                                    : Text(
                                                        "Save".tr,
                                                        style: TextStyle(
                                                            color: white,
                                                            fontSize: size_9,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                              ),
                                            ),
                                            onTapUp: (value) {
                                              setState(() {
                                                progressBar = true;
                                              });
                                            },
                                            onTap: uploadedCheckEwayBill),
                                      )),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    )
                  : (providerData.WeightReceiptPhotoFile != null)
                      ? SafeArea(
                          child: Scaffold(
                            body: Column(
                              children: [
                                Container(
                                  height: size_15 + 30,
                                  color: whiteBackgroundColor,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Get.back();
                                                  setState(() {
                                                    providerData.LrPhotoFile =
                                                        null;
                                                    providerData.LrPhoto64 =
                                                        null;

                                                    providerData
                                                            .EwayBillPhotoFile =
                                                        null;
                                                    providerData
                                                        .EwayBillPhoto64 = null;

                                                    providerData
                                                            .WeightReceiptPhotoFile =
                                                        null;
                                                    providerData
                                                            .WeightReceiptPhoto64 =
                                                        null;

                                                    providerData.PodPhotoFile =
                                                        null;
                                                    providerData.PodPhoto64 =
                                                        null;
                                                  });
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
                                              "Upload Image".tr,
                                              style: TextStyle(
                                                  fontSize: size_10 - 1,
                                                  fontWeight: boldWeight,
                                                  color: darkBlueColor,
                                                  letterSpacing: -0.408),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: size_3,
                                  color: darkGreyColor,
                                ),
                                providerData.WeightReceiptPhotoFile != null
                                    ? Expanded(
                                        child: SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, left: 10, right: 10),
                                            child: kIsWeb
                                                ? Image.network(providerData
                                                    .WeightReceiptPhotoFile!
                                                    .path)
                                                : Image.file(providerData
                                                    .WeightReceiptPhotoFile!),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Row(children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 7.5,
                                          bottom: 10,
                                          top: 10),
                                      child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          color: Color(0xFFE75347),
                                          child: Container(
                                            height: space_10,
                                            child: Center(
                                              child: Text(
                                                "Discard".tr,
                                                style: TextStyle(
                                                    color: white,
                                                    fontSize: size_9,
                                                    fontWeight:
                                                        mediumBoldWeight),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              providerData
                                                      .WeightReceiptPhotoFile =
                                                  null;
                                            });
                                            providerData
                                                .WeightReceiptPhotoFile = null;
                                          }),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.5,
                                            right: 15,
                                            bottom: 10,
                                            top: 10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: InkWell(
                                              child: Container(
                                                color: Color(0xFF09B778),
                                                height: space_10,
                                                child: Center(
                                                  child: progressBar
                                                      ? CircularProgressIndicator(
                                                          color: white,
                                                        )
                                                      : Text(
                                                          "Save".tr,
                                                          style: TextStyle(
                                                              color: white,
                                                              fontSize: size_9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                ),
                                              ),
                                              onTapUp: (value) {
                                                setState(() {
                                                  progressBar = true;
                                                });
                                              },
                                              onTap:
                                                  uploadedCheckWeightReceipt),
                                        )),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        )
                      : (providerData.PodPhotoFile != null)
                          ? SafeArea(
                              child: Scaffold(
                                body: Column(
                                  children: [
                                    Container(
                                      height: size_15 + 30,
                                      color: whiteBackgroundColor,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // Get.back();
                                                      setState(() {
                                                        providerData
                                                            .LrPhotoFile = null;
                                                        providerData.LrPhoto64 =
                                                            null;

                                                        providerData
                                                                .EwayBillPhotoFile =
                                                            null;
                                                        providerData
                                                                .EwayBillPhoto64 =
                                                            null;

                                                        providerData
                                                                .WeightReceiptPhotoFile =
                                                            null;
                                                        providerData
                                                                .WeightReceiptPhoto64 =
                                                            null;

                                                        providerData
                                                                .PodPhotoFile =
                                                            null;
                                                        providerData
                                                            .PodPhoto64 = null;
                                                      });
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
                                                  "Upload Image".tr,
                                                  style: TextStyle(
                                                      fontSize: size_10 - 1,
                                                      fontWeight: boldWeight,
                                                      color: darkBlueColor,
                                                      letterSpacing: -0.408),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: size_3,
                                      color: darkGreyColor,
                                    ),
                                    providerData.PodPhotoFile != null
                                        ? Expanded(
                                            child: SizedBox(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0,
                                                    left: 10,
                                                    right: 10),
                                                child: kIsWeb
                                                    ? Image.network(providerData
                                                        .PodPhotoFile!.path)
                                                    : Image.file(providerData
                                                        .PodPhotoFile!),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Row(children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              right: 7.5,
                                              bottom: 10,
                                              top: 10),
                                          child: MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              color: Color(0xFFE75347),
                                              child: Container(
                                                height: space_10,
                                                child: Center(
                                                  child: Text(
                                                    "Discard".tr,
                                                    style: TextStyle(
                                                        color: white,
                                                        fontSize: size_9,
                                                        fontWeight:
                                                            mediumBoldWeight),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  providerData.PodPhotoFile =
                                                      null;
                                                });
                                                providerData.PodPhotoFile =
                                                    null;
                                              }),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 7.5,
                                                right: 15,
                                                bottom: 10,
                                                top: 10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: InkWell(
                                                  child: Container(
                                                    color: Color(0xFF09B778),
                                                    height: space_10,
                                                    // width: space_30,
                                                    child: Center(
                                                      child: progressBar
                                                          ? CircularProgressIndicator(
                                                              color: white,
                                                            )
                                                          : Text(
                                                              "Save".tr,
                                                              style: TextStyle(
                                                                  color: white,
                                                                  fontSize:
                                                                      size_9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                      // ),
                                                    ),
                                                  ),
                                                  onTapUp: (value) {
                                                    setState(() {
                                                      progressBar = true;
                                                    });
                                                  },
                                                  onTap: uploadedCheckPod),
                                            )),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            )
                          : SafeArea(
                              child: SingleChildScrollView(
                                // this will be displayed if any document is not selected for uploading.
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: Container(
                                        color: white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, top: space_5),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.back();
                                              providerData.LrPhotoFile = null;
                                              providerData.LrPhoto64 = null;

                                              providerData.EwayBillPhotoFile =
                                                  null;
                                              providerData.EwayBillPhoto64 =
                                                  null;

                                              providerData
                                                      .WeightReceiptPhotoFile =
                                                  null;
                                              providerData
                                                  .WeightReceiptPhoto64 = null;

                                              providerData.PodPhotoFile = null;
                                              providerData.PodPhoto64 = null;
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
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: space_8),
                                              child: Text(
                                                "Loads Details",
                                                style: TextStyle(
                                                    fontSize: size_10 - 1,
                                                    fontWeight: boldWeight,
                                                    color: darkBlueColor,
                                                    letterSpacing: -0.408),
                                              ),
                                            ),
                                            Text(
                                              "On-Going",
                                              style: TextStyle(
                                                  fontSize: size_10 - 10,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(space_2),
                                      child: Material(
                                        elevation: 5,
                                        child: Flexible(
                                          child: SizedBox(
                                            child: Container(
                                              color: white,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: space_4,
                                                  horizontal: isMobile
                                                      ? screenHeight * 0.001
                                                      : screenWidth * 0.01,
                                                ),
                                                child: (loadData != null)
                                                    ? Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image(
                                                                image: AssetImage(
                                                                    'assets/icons/greenFilledCircleIcon.png'),
                                                                height: space_2,
                                                                width: space_2,
                                                              ),
                                                              SizedBox(
                                                                  width:
                                                                      space_4),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "${widget.loadingPoint}",
                                                                    style: GoogleFonts
                                                                        .montserrat(
                                                                      color:
                                                                          black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          size_11,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    wrapWords(
                                                                      ' ${formatText(loadData?['loadingPoint'])}, ${loadData?['loadingPointCity']} , ${loadData?['loadingPointState']}',
                                                                      50,
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          size_8,
                                                                      color:
                                                                          darkBlueColor,
                                                                    ),
                                                                    maxLines: 5,
                                                                    softWrap:
                                                                        true,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .visible,
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  width:
                                                                      space_4),
                                                              Flexible(
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      DottedLine(
                                                                    lineThickness:
                                                                        size_1,
                                                                    dashColor:
                                                                        liveasyGreen,
                                                                  ),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      DottedLine(
                                                                    lineThickness:
                                                                        size_1,
                                                                    dashColor:
                                                                        red,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width:
                                                                      space_4),
                                                              Image(
                                                                image: AssetImage(
                                                                    'assets/icons/hollowRedCircle.png'),
                                                                height: space_2,
                                                                width: space_2,
                                                              ),
                                                              SizedBox(
                                                                  width:
                                                                      space_4),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "${widget.unloadingPoint}",
                                                                    style: GoogleFonts
                                                                        .montserrat(
                                                                      color:
                                                                          black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          size_11,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    wrapWords(
                                                                      ' ${formatText(loadData?['unloadingPoint'])}, ${loadData?['unloadingPointCity']} , ${loadData?['unloadingPointState']}',
                                                                      50,
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          size_8,
                                                                      color:
                                                                          darkBlueColor,
                                                                    ),
                                                                    maxLines: 5,
                                                                    softWrap:
                                                                        true,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .visible,
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height: space_3),
                                                          const Divider(
                                                              thickness: 2),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              vertical:
                                                                  screenHeight /
                                                                      90,
                                                            ),
                                                            child: Container(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  vertical:
                                                                      20.0,
                                                                  horizontal: isMobile
                                                                      ? screenHeight *
                                                                          0.001
                                                                      : screenWidth *
                                                                          0.01,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                        width:
                                                                            50),
                                                                    Image(
                                                                        image: AssetImage(
                                                                            'assets/icons/box.png')),
                                                                    SizedBox(
                                                                        width:
                                                                            space_2),
                                                                    Text(
                                                                      "DOC",
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            veryDarkGrey,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            mediumBoldWeight,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            100),
                                                                    Image(
                                                                        image: AssetImage(
                                                                            'assets/icons/truckDoc.png')),
                                                                    SizedBox(
                                                                        width:
                                                                            space_2),
                                                                    Text(
                                                                      "${loadData?['weight']} tons | ${loadData?['truckType']} | ${loadData?['noOfTyres']} Tyres  ",
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            veryDarkGrey,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            mediumBoldWeight,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(space_2),
                                      child: Material(
                                        elevation: 5,
                                        child: SizedBox(
                                          height: space_18 - 3,
                                          width: screenWidth * 0.9,
                                          child: Container(
                                            color: white,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: space_4,
                                                  horizontal: isMobile
                                                      ? screenHeight * 0.001
                                                      : screenWidth * 0.01),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: space_4),
                                                        child: Text(
                                                          'Track Vehicle',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            color: black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: isMobile
                                                                ? screenWidth *
                                                                    0.040
                                                                : screenHeight *
                                                                    0.02,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: space_75,
                                                    ),
                                                    gpsButton(
                                                      gpsData:
                                                          widget.gpsDataList[0],
                                                      truckApproved: true,
                                                      TruckNo: widget
                                                          .loadAllDataModel
                                                          .truckNo,
                                                      totalDistance:
                                                          widget.totalDistance,
                                                      device: widget.device,
                                                    ),
                                                    SizedBox(
                                                      width: space_15,
                                                    ),
                                                    simTrackingButton(
                                                      gpsData:
                                                          widget.gpsDataList[0],
                                                      truckApproved: true,
                                                      TruckNo: widget
                                                          .loadAllDataModel
                                                          .truckNo,
                                                      totalDistance:
                                                          widget.totalDistance,
                                                      device: widget.device,
                                                    ),
                                                    SizedBox(
                                                      width: space_15,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DashboardScreen(
                                                                    visibleWidget:
                                                                        MapScreen(
                                                                      loadingPoint:
                                                                          widget
                                                                              .loadingPoint,
                                                                      unloadingPoint:
                                                                          widget
                                                                              .unloadingPoint,
                                                                      truckNumber:
                                                                          widget
                                                                              .truckNo,
                                                                    ),
                                                                    index: 1000,
                                                                    selectedIndex:
                                                                        screens.indexOf(
                                                                            ordersScreen),
                                                                  )),
                                                        );
                                                      },
                                                      child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      screenWidth *
                                                                          0.005),
                                                          height: space_8,
                                                          width: space_20,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        space_2)),
                                                            color:
                                                                darkBlueColor,
                                                          ),
                                                          child: Image.asset(
                                                              'assets/icons/fastagButton.png')),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(space_2),
                                      child: Material(
                                        elevation: 5,
                                        child: SizedBox(
                                          height: space_18,
                                          width: screenWidth * 0.9,
                                          child: Container(
                                            color: white,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: space_4,
                                                  horizontal: isMobile
                                                      ? screenHeight * 0.001
                                                      : screenWidth * 0.01),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: space_4),
                                                      child: Text(
                                                        'Driver Details',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: isMobile
                                                              ? screenWidth *
                                                                  0.040
                                                              : screenHeight *
                                                                  0.02,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: size_5),
                                                      child: SizedBox(
                                                        height: size_8,
                                                        width: size_8,
                                                        child: Image.asset(
                                                            'assets/icons/dropdownBlue.png'),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(space_2),
                                      child: Material(
                                        elevation: 5,
                                        child: SizedBox(
                                          height: space_32,
                                          width: screenWidth * 0.9,
                                          child: Container(
                                            color: white,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: space_4,
                                                  horizontal: isMobile
                                                      ? screenHeight * 0.001
                                                      : screenWidth * 0.01),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: space_4),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: space_2),
                                                      child:
                                                          UpdateDriverTruckButton(
                                                        loadAllDataModel: widget
                                                            .loadAllDataModel,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                              'assets/icons/driverIcon.png'),
                                                          height: space_5,
                                                          width: space_5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      space_4),
                                                          child: Text(
                                                            '${widget.driverName}',
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: isMobile
                                                                  ? screenWidth *
                                                                      0.040
                                                                  : screenHeight *
                                                                      0.02,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: space_4),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                                'assets/icons/phoneIcon.png'),
                                                            height: space_5,
                                                            width: space_5,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left:
                                                                        space_4),
                                                            child: Text(
                                                              '${widget.driverPhoneNum}',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                color: black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: isMobile
                                                                    ? screenWidth *
                                                                        0.040
                                                                    : screenHeight *
                                                                        0.02,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(space_2),
                                      child: Material(
                                        elevation: 5,
                                        child: Container(
                                            color: white,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3.75,
                                            width: screenWidth * 0.9,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3) /
                                                          5,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.black,
                                                            width: 1)),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) /
                                                            7,
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(),
                                                          color: Color.fromRGBO(
                                                              9, 183, 120, 1),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Booking Date",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) *
                                                            2 /
                                                            7,
                                                        child: Center(
                                                            child: Text(
                                                                "${widget.bookingDate}")),
                                                      ),
                                                      Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) /
                                                            7,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              9, 183, 120, 1),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Driver Number",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) *
                                                            2 /
                                                            7,
                                                        child: Center(
                                                            child: Text(
                                                          "${widget.driverPhoneNum}",
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3) /
                                                          5,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.black,
                                                            width: 1)),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) /
                                                            7,
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(),
                                                          color: Color.fromRGBO(
                                                              9, 183, 120, 1),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Truck Number",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) *
                                                            2 /
                                                            7,
                                                        child: Center(
                                                            child: Text(
                                                                "${widget.truckNo}")),
                                                      ),
                                                      Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) /
                                                            7,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              9, 183, 120, 1),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "LR Number",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) *
                                                            2 /
                                                            7,
                                                        child: Center(
                                                            child: Text(
                                                          "PK54323456738490",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: black),
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3) /
                                                          5,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.black,
                                                            width: 1)),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) /
                                                            7,
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(),
                                                          color: Color.fromRGBO(
                                                              9, 183, 120, 1),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Driver Name",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) *
                                                            2 /
                                                            7,
                                                        child: Center(
                                                            child: Text(
                                                          "${widget.driverName}",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: black),
                                                        )),
                                                      ),
                                                      Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) /
                                                            7,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              9, 183, 120, 1),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Freight",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) *
                                                            2 /
                                                            7,
                                                        child: Center(
                                                            child: Text(
                                                          "Rs 19,000",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: black),
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3) /
                                                          5,
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.black,
                                                            width: 1)),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) /
                                                            7,
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(),
                                                          color: Color.fromRGBO(
                                                              9, 183, 120, 1),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Sim-Tracking Status",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) *
                                                            2 /
                                                            7,
                                                        child: ElevatedButton(
                                                            onPressed: () {},
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                              side: MaterialStateProperty
                                                                  .all(BorderSide(
                                                                      color: getStatusColor(
                                                                          status),
                                                                      width:
                                                                          2.0)),
                                                            ),
                                                            child: Text(
                                                              ' $status',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                color:
                                                                    getStatusColor(
                                                                        status),
                                                              ),
                                                            )),
                                                      ),
                                                      Container(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) /
                                                            7,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              9, 183, 120, 1),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "Vehcile Details",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                60) *
                                                            2 /
                                                            7,
                                                        child: Center(
                                                            child: VahanButton(
                                                          truckNo:
                                                              widget.truckNo,
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(space_2),
                                      child: Material(
                                        elevation: 5,
                                        child: SizedBox(
                                          height: space_18,
                                          width: screenWidth * 0.9,
                                          child: Container(
                                            color: white,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: space_4,
                                                  horizontal: isMobile
                                                      ? screenHeight * 0.001
                                                      : screenWidth * 0.01),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: space_4),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "Sim-Tracking Consent",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              color: black,
                                                              fontSize: isMobile
                                                                  ? size_9
                                                                  : size_12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    SizedBox(
                                                      height: space_4,
                                                      width: space_14,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    space_2),
                                                        border: Border.all(
                                                            color:
                                                                darkBlueColor),
                                                      ),
                                                      child: DropdownButton<
                                                          String>(
                                                        value: selectedOperator,
                                                        icon: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Image.asset(
                                                              "assets/icons/dropdown_doc.png"),
                                                        ),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize:
                                                                    size_9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    darkBlueColor),
                                                        underline: Container(
                                                          height: 2,
                                                          color: white,
                                                        ),
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            selectedOperator =
                                                                newValue;
                                                          });
                                                        },
                                                        items: operatorOptions
                                                            .map((String
                                                                operator) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      space_2),
                                                              child: Container(
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              space_2),
                                                                  child: Text(
                                                                    operator,
                                                                    style: GoogleFonts.montserrat(
                                                                        fontSize:
                                                                            size_9,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color:
                                                                            darkBlueColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            value: operator,
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: space_7),
                                                      //Button to send the consent to the user
                                                      child: SendConsentButton(
                                                        mobileno: widget
                                                            .driverPhoneNum,
                                                        selectedOperator:
                                                            selectedOperator,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          space_4, space_4, space_4, 0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Upload Documents",
                                          style: TextStyle(
                                              color: const Color.fromRGBO(
                                                  21, 41, 104, 1),
                                              fontWeight: boldWeight,
                                              fontSize: size_10),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    Responsive.isMobile(context)
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    space_4,
                                                    space_2,
                                                    space_4,
                                                    0),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Loading Documents".tr,
                                                      style: TextStyle(
                                                          color: grey,
                                                          fontSize: size_9,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
                                                    )),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    space_4,
                                                    space_1,
                                                    space_4,
                                                    0),
                                                child: Text(
                                                  "Upload Loadoing document photos for advanced payment"
                                                      .tr,
                                                  style: const TextStyle(
                                                      color: grey),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      space_4,
                                                      space_4,
                                                      space_4,
                                                      0),
                                                  child: docInputLr(
                                                      providerData:
                                                          providerData,
                                                      bookingId:
                                                          widget.bookingId)),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      space_4,
                                                      space_4,
                                                      space_4,
                                                      0),
                                                  child: docInputEWBill(
                                                      providerData:
                                                          providerData,
                                                      bookingId:
                                                          widget.bookingId)),
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      space_4,
                                                      space_4,
                                                      space_4,
                                                      0),
                                                  child: docInputWgtReceipt(
                                                    providerData: providerData,
                                                    bookingId: widget.bookingId,
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    space_4,
                                                    space_4,
                                                    space_4,
                                                    0),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Uploading Documents".tr,
                                                      style: TextStyle(
                                                          color: grey,
                                                          fontSize: size_9,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
                                                    )),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    space_4,
                                                    space_1,
                                                    space_4,
                                                    0),
                                                child: Text(
                                                  "Upload unloadoing document photos for final payment"
                                                      .tr,
                                                  style: const TextStyle(
                                                      color: grey),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    space_4,
                                                    space_4,
                                                    space_4,
                                                    space_4),
                                                child: docInputPod(
                                                  providerData: providerData,
                                                  bookingId: widget.bookingId,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            space_4,
                                                            space_4,
                                                            space_4,
                                                            space_4),
                                                    child: docInputLr(
                                                        providerData:
                                                            providerData,
                                                        bookingId:
                                                            widget.bookingId),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              space_4,
                                                              space_4,
                                                              space_4,
                                                              space_4),
                                                      child: docInputEWBill(
                                                          providerData:
                                                              providerData,
                                                          bookingId: widget
                                                              .bookingId)),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 70,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            space_4,
                                                            space_4,
                                                            space_4,
                                                            space_4),
                                                    child: docInputWgtReceipt(
                                                      providerData:
                                                          providerData,
                                                      bookingId:
                                                          widget.bookingId,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            space_4,
                                                            space_4,
                                                            space_4,
                                                            space_4),
                                                    child: docInputPod(
                                                      providerData:
                                                          providerData,
                                                      bookingId:
                                                          widget.bookingId,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          ),
                                    const SizedBox(height: 50),
                                  ],
                                ),
                              ),
                            ),
        ),
      ),
    );
  }
}

//Color for each status
Color getStatusColor(String status) {
  switch (status) {
    case 'APPROVED':
      return liveasyGreen;
    case 'PENDING':
      return orangeColor;
    case 'REJECTED':
      return red;
    default:
      return black;
  }
}
