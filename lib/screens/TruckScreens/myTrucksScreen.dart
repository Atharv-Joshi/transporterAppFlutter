import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/truckApis/getTruckDataWithPageNo.dart';
import 'package:liveasy/widgets/alertDialog/nextUpdateAlertDialog.dart';
import 'package:liveasy/widgets/buttons/addTruckButton.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import 'package:liveasy/widgets/loadingWidgets/truckLoadingWidgets.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';

class MyTrucks extends StatefulWidget {
  @override
  _MyTrucksState createState() => _MyTrucksState();
}

class _MyTrucksState extends State<MyTrucks> {
  //TransporterId controller
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  // Truck Model List used to  create cards
  var truckDataList = [];

  int i = 0;

  bool loading = false;
  bool bottomProgressTruck = false;

  @override
  void initState() {
    super.initState();

    if (this.mounted) {
      setState(() {
        loading = true;
      });
    }

    getTruckData(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent * 0.7) {
        i = i + 1;
        getTruckData(i);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ProviderData providerData = Provider.of<ProviderData>(context);
    // providerData.resetTruckFilters();
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
        height: MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            space_4,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: space_3,
                    ),
                    HeadingTextWidget(AppLocalizations.of(context)!.my_truck),
                    // HelpButtonWidget(),
                  ],
                ),
                HelpButtonWidget(),
              ],
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: space_3),
                child: SearchLoadWidget(
                  hintText: AppLocalizations.of(context)!.search,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => NextUpdateAlertDialog());
                  },
                )),

            //LIST OF TRUCK CARDS---------------------------------------------
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  loading
                      ? TruckLoadingWidgets()
                      : truckDataList.isEmpty
                          ? Container(
                              // height: MediaQuery.of(context).size.height * 0.27,
                              margin: EdgeInsets.only(top: 153),
                              child: Column(
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'assets/images/TruckListEmptyImage.png'),
                                    height: 127,
                                    width: 127,
                                  ),
                                  Text(
                                    'Looks like you have not added any Trucks!',
                                    style: TextStyle(
                                        fontSize: size_8, color: grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              color: lightNavyBlue,
                              onRefresh: () {
                                return getTruckData(0);
                              },
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.only(bottom: space_15),
                                controller: scrollController,
                                itemCount: truckDataList.length,
                                itemBuilder: (context, index) => (index ==
                                        truckDataList.length - 1)
                                    ? Visibility(
                                        visible: bottomProgressTruck,
                                        child:
                                            bottomProgressBarIndicatorWidget())
                                    : MyTruckCard(
                                        truckData: truckDataList[index],
                                      ),
                              ),
                            ),
                  // {
                  //   return MyTruckCard(
                  //     truckData: truckDataList[index],
                  // truckId: .truckId,
                  // truckApproved: truckDataList[index].truckApproved,
                  // truckNo: truckDataList[index].truckNo,
                  // truckType: truckDataList[index].truckType,
                  // tyres: truckDataList[index].tyresString,
                  // driverName: truckDataList[index].driverName,
                  // phoneNum: truckDataList[index].driverNum,
                  // imei: truckDataList[index].imei,
                  //),
                  // }),
                  Padding(
                    padding: EdgeInsets.only(bottom: space_2),
                    child: Container(
                        margin: EdgeInsets.only(bottom: space_2),
                        child: AddTruckButton()),
                  ),
                ],
              ),
            ),

            //--------------------------------------------------------------
          ],
        ),
      )),
    );
  } //build

  getTruckData(int i) async {
    if (this.mounted) {
      setState(() {
        bottomProgressTruck = true;
      });
    }
    var truckDataListForPagei = await getTruckDataWithPageNo(i);
    for (var truckData in truckDataListForPagei) {
      truckDataList.add(truckData);
    }
    if (this.mounted) {
      setState(() {
        loading = false;
        bottomProgressTruck = false;
      });
    }
  } //getTruckData

} //class
