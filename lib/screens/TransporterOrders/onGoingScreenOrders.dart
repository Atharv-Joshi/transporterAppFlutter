import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/bookingApiCallsOrders.dart';
import 'package:liveasy/functions/ongoingTrackUtils/getDeviceData.dart';
import 'package:liveasy/functions/ongoingTrackUtils/getPositionByDeviceId.dart';
import 'package:liveasy/functions/ongoingTrackUtils/getTraccarSummaryByDeviceId.dart';
import 'package:liveasy/models/deviceModel.dart';
import 'package:liveasy/models/gpsDataModel.dart';
import 'package:liveasy/models/onGoingCardModel.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/screens/TransporterOrders/onGoingOrdersApiCall.dart';
import 'package:liveasy/screens/TransporterOrders/onGoingOrdersCardNew.dart';
import 'package:liveasy/widgets/LoadsTableHeader.dart';
import 'package:liveasy/widgets/invoice_screen/shimmer_invoice.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/onGoingLoadingWidgets.dart';

class OngoingScreenOrders extends StatefulWidget {
  @override
  State<OngoingScreenOrders> createState() => _OngoingScreenOrdersState();
}

class _OngoingScreenOrdersState extends State<OngoingScreenOrders> {
  GpsDataModel? gpsData;

  var devicelist = [];
  // var gpsDataList = [];
  // late List<dynamic> gpsDataList = [];
  List<dynamic> gpsDataList = [];
  // List.generate(10, (index) => 0);
  var gpsList = [];

  bool getMyTruckPostionBoolValue = false;
  bool initfunctionBoolValue = false;

  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
  String? from = DateTime.now().toIso8601String();
  String? to = DateTime.now().toIso8601String();
  String? totalDistance;

  final BookingApiCallsOrders bookingApiCallsOrders = BookingApiCallsOrders();

  int i = 0;

  bool loading = true;
  bool OngoingProgress = false;

  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  final String bookingApiUrl = dotenv.get(
      'bookingApiUrl'); //for getting the bookingApiUrl form the .env folder

  List<OngoingCardModel> modelList = [];
  // Future<dynamic>? modelList = [];
  ScrollController scrollController = ScrollController();
  TextEditingController searchTextController = TextEditingController();
  List<OngoingCardModel> searchedLoadList = [];
  bool moreitems = true;

  //for getting the Ongoing Orders Data
  getOnGoingOrders(int i) async {
    if (this.mounted) {
      setState(() {
        OngoingProgress = true;
      });
    }
    var bookingDataListWithPagei = await onGoingOrdersApiCall(i);
    if (bookingDataListWithPagei == []) {
      setState(() {
        moreitems = false;
      });
    }
    if (moreitems) {
      for (var bookingData in bookingDataListWithPagei) {
        modelList.add(bookingData);
      }
    }
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        loading = false;
        OngoingProgress = false;
      });
    }
    await initializeGps();
  }

  initializeGps() async {
    for (int i = 0; i < modelList.length; i++) {
      await getMyTruckPosition(i);
      // await initFunction(i);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    // nullData();

    loading = true;
    getOnGoingOrders(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        getOnGoingOrders(i);
      }
    });
  }

  String searchedTruck = "";
  late String selectedTruck;
  late int selectedDeviceId;
  int selectedIndex = -1;
  var searchedModelList = [];
  var searchedDeviceList = [];
  var searchedGpsList = [];
  List truckList = [];
  List deviceIdList = [];

  void searchoperation(String searchText) {
// searchresult. clear() ;
    if (searchText != null) {
      searchedModelList.clear();
      searchedDeviceList.clear();
      searchedGpsList.clear();

      for (int i = 0; i < modelList.length; i++) {
        String truckNo = modelList[i].truckNo.toString();
        String loadingPoint = modelList[i].loadingPointCity.toString();
        String unLoadingPoint = modelList[i].unloadingPointCity.toString();
        String driverName = modelList[i].driverName.toString();
        String bookingDate = modelList[i].bookingDate.toString();

        if ((truckNo.toLowerCase().contains(searchText.toLowerCase())) ||
            (loadingPoint.toLowerCase().contains(searchText.toLowerCase())) ||
            (unLoadingPoint.toLowerCase().contains(searchText.toLowerCase())) ||
            (driverName.toLowerCase().contains(searchText.toLowerCase())) ||
            (bookingDate.toLowerCase().contains(searchText.toLowerCase()))) {
          setState(() {
            searchedModelList.add(modelList[i]);
            searchedDeviceList.add(devicelist[i]);
            searchedGpsList.add(gpsDataList[i]);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            space_8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: space_2,
            ),
            Row(
              children: [
                Expanded(
                    flex: (Responsive.isMobile(context)) ? 8 : 5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: space_2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(space_6),
                        color: white,
                        boxShadow: const [
                          BoxShadow(
                            color: lightGrey,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      //Search bar
                      child: TextField(
                        controller: searchTextController,
                        onChanged: (value) {
                          setState(() {
                            searchedTruck = value;
                          });
                          searchoperation(searchedTruck);
                        },
                        style: GoogleFonts.montserrat(
                            color: black, fontSize: size_8),
                        cursorColor: kLiveasyColor,
                        cursorWidth: 1,
                        mouseCursor: SystemMouseCursors.click,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              bottom: 0, left: 5, right: 5, top: 15),
                          prefixIcon:
                              const Icon(Icons.search, color: grey, size: 25),
                          hintText: "Search",
                          hintStyle: GoogleFonts.montserrat(
                              fontSize: size_8,
                              color: grey,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            loading
                ? Expanded(
                    child: kIsWeb && Responsive.isDesktop(context)
                        ? ShimmerEffect()
                        : const OnGoingLoadingWidgets())
                : modelList.length == 0
                    ? Container(
                        margin: EdgeInsets.only(top: 153),
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage('assets/images/EmptyLoad.png'),
                              height: 127,
                              width: 127,
                            ),
                            Text(
                              'noOnGoingLoad'.tr,
                              // 'Looks like you have not added any Loads!',
                              style: GoogleFonts.montserrat(
                                  fontSize: size_8, color: grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: RefreshIndicator(
                          color: lightNavyBlue,
                          onRefresh: () {
                            setState(() {
                              modelList.clear();
                              moreitems = true;
                              i = 0;
                              gpsDataList.clear();
                              loading = true;
                            });
                            return getOnGoingOrders(0);
                          },
                          //For web this code will be executed
                          child: (kIsWeb && Responsive.isDesktop(context))
                              ? Card(
                                  surfaceTintColor: Colors.transparent,
                                  margin: EdgeInsets.only(bottom: 5),
                                  shadowColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  elevation: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LoadsTableHeader(
                                        loadingStatus: 'On-Going',
                                        screenWidth:
                                            MediaQuery.of(context).size.width,
                                      ),
                                      searchedTruck ==
                                              "" //The below list view is used to show the ongoing details on web
                                          ? Expanded(
                                              flex: 4,
                                              child: SingleChildScrollView(
                                                controller: scrollController,
                                                child: ListView.separated(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    itemCount: modelList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      initFunction(index);
                                                      return (index ==
                                                              (modelList
                                                                  .length))
                                                          ? Visibility(
                                                              visible:
                                                                  OngoingProgress,
                                                              child:
                                                                  bottomProgressBarIndicatorWidget(),
                                                            )
                                                          : (index <
                                                                  gpsDataList
                                                                      .length)
                                                              ? Row(
                                                                  children: [
                                                                    onGoingOrdersCardNew(
                                                                      loadAllDataModel:
                                                                          modelList[
                                                                              index],
                                                                      gpsDataList:
                                                                          gpsDataList[
                                                                              index],
                                                                      totalDistance:
                                                                          totalDistance,
                                                                      device: devicelist[
                                                                          index],
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container();
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const Divider(
                                                              thickness: 1,
                                                              height: 0,
                                                              color:
                                                                  Colors.grey,
                                                            )),
                                              ),
                                            ) //this code is executed when we add some text to search in ongoing Screens
                                          : Expanded(
                                              flex: 4,
                                              child: SingleChildScrollView(
                                                controller: scrollController,
                                                child: ListView.separated(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    itemCount: searchedModelList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      initFunction(index);
                                                      return (index ==
                                                              (searchedModelList
                                                                  .length))
                                                          ? Visibility(
                                                              visible:
                                                                  OngoingProgress,
                                                              child:
                                                                  bottomProgressBarIndicatorWidget(),
                                                            )
                                                          : (index <
                                                                  searchedGpsList
                                                                      .length)
                                                              ? Row(
                                                                  children: [
                                                                    onGoingOrdersCardNew(
                                                                      loadAllDataModel:
                                                                          searchedModelList[
                                                                              index],
                                                                      gpsDataList:
                                                                          searchedGpsList[
                                                                              index],
                                                                      totalDistance:
                                                                          totalDistance,
                                                                      device: searchedDeviceList[
                                                                          index],
                                                                    ),
                                                                  ],
                                                                )
                                                              : Container();
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            const Divider(
                                                              thickness: 1,
                                                              height: 0,
                                                              color:
                                                                  Colors.grey,
                                                            )),
                                              ))
                                    ],
                                  ),
                                ) //Below code is for mobile
                              : SingleChildScrollView(
                                  controller: scrollController,
                                  child: searchedTruck == ""
                                      ?
                                      // child:
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding:
                                              EdgeInsets.only(bottom: space_10),
                                          itemCount: modelList.length,
                                          itemBuilder: (context, index) {
                                            // getMyTruckPosition(index);
                                            initFunction(index);
                                            return (index == modelList.length)
                                                ? Visibility(
                                                    visible: OngoingProgress,
                                                    child:
                                                        bottomProgressBarIndicatorWidget())
                                                : (index < gpsDataList.length)
                                                    ? onGoingOrdersCardNew(
                                                        loadAllDataModel:
                                                            modelList[index],
                                                        gpsDataList:
                                                            gpsDataList[index],
                                                        totalDistance:
                                                            totalDistance,
                                                        device:
                                                            devicelist[index],
                                                      )
                                                    : Container();
                                          })
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding:
                                              EdgeInsets.only(bottom: space_10),
                                          itemCount: searchedModelList.length,
                                          itemBuilder: (context, index) {
                                            // getMyTruckPosition(index);
                                            initFunction(index);
                                            return (index ==
                                                    searchedModelList.length)
                                                ? Visibility(
                                                    visible: OngoingProgress,
                                                    child:
                                                        bottomProgressBarIndicatorWidget())
                                                : (index <
                                                        searchedGpsList.length)
                                                    ? onGoingOrdersCardNew(
                                                        loadAllDataModel:
                                                            searchedModelList[
                                                                index],
                                                        gpsDataList:
                                                            searchedGpsList[
                                                                index],
                                                        totalDistance:
                                                            totalDistance,
                                                        device:
                                                            searchedDeviceList[
                                                                index],
                                                      )
                                                    : Container();
                                          }),
                                  // ]
                                ),
                        ),
                      )
          ],
        ));
    // ),
    // );
  }

  // List<GpsDataModel> gpsDataList;
  // Future<bool>
  //This funtion is used to get the truck position from device ID
  getMyTruckPosition(int index) async {
    List<DeviceModel> devices =
        await getDeviceByDeviceId(modelList[index].deviceId.toString());
    List<GpsDataModel> gpsDataAll =
        await getPositionByDeviceId(modelList[index].deviceId.toString());

    // devicelist.clear();

    for (var device in devices) {
      setState(() {
        devicelist.add(device);
      });
    }

    gpsList = List.filled(devices.length, null, growable: true);

    for (int i = 0; i < gpsDataAll.length; i++) {
      getGPSData(gpsDataAll[i], i);
    }
    // gpsDataList.add(gpsList);
    setState(() {
      // gpsDataList[i] = gpsList;
      gpsDataList.add(gpsList);
      getMyTruckPostionBoolValue = true;
    });
    // return true;
    // return getMyTruckPostionBoolValue;
  }

  void getGPSData(var gpsData, int i) async {
    gpsList.removeAt(i);

    gpsList.insert(i, gpsData);
  }

  void initFunction(index) async {
    List<GpsDataModel> gpsRoute1 = await getTraccarSummaryByDeviceId(
        deviceId: modelList[index].deviceId, from: from, to: to);

    totalDistance = (gpsRoute1[0].distance! / 1000).toStringAsFixed(2);
    initfunctionBoolValue = true;
    // return initfunctionBoolValue;
  }
}
