import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/navigationIndexController.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/models/popupModelForMyLoads.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenLoacationDetails.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
import 'package:liveasy/widgets/LoadEndPointTemplate.dart';
import 'package:liveasy/widgets/buttons/repostButton.dart';
import 'package:liveasy/widgets/linePainter.dart';
import 'package:liveasy/widgets/buttons/viewBidsButton.dart';
import 'package:provider/provider.dart';
import 'priceContainer.dart';
import 'package:get/get.dart';
import 'package:liveasy/functions/loadApiCalls.dart';

// ignore: must_be_immutable
class MyLoadsCard extends StatelessWidget {
  LoadDetailsScreenModel loadDetailsScreenModel;

  MyLoadsCard({required this.loadDetailsScreenModel});

  TruckFilterVariables truckFilterVariables = TruckFilterVariables();

  @override
  Widget build(BuildContext context) {
    if (truckFilterVariables.truckTypeValueList
        .contains(loadDetailsScreenModel.truckType)) {
      loadDetailsScreenModel.truckType = truckFilterVariables.truckTypeTextList[
          truckFilterVariables.truckTypeValueList
              .indexOf(loadDetailsScreenModel.truckType)];
    }

    if (loadDetailsScreenModel.unitValue == 'PER_TON') {
      loadDetailsScreenModel.unitValue = 'tonne';
    } else if (loadDetailsScreenModel.unitValue == 'PER_TRUCK') {
      loadDetailsScreenModel.unitValue = 'truck';
    }

    return Container(
      margin: EdgeInsets.only(bottom: space_2),
      child: Card(
        color: loadDetailsScreenModel.status == "EXPIRED"
            ? cancelledBiddingBackground
            : Colors.white,
        elevation: 3,
        child: Container(
          padding:
              EdgeInsets.only(bottom: space_2, left: space_2, right: space_2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posted Date : ${loadDetailsScreenModel.postLoadDate}',
                    style: TextStyle(
                        fontSize: size_6,
                        color: veryDarkGrey,
                        fontFamily: 'montserrat'),
                  ),
                  loadDetailsScreenModel.status == 'EXPIRED'
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.more_vert, color: black),
                        )
                      : PopupMenuButton<popupMenuforloads>(
                          offset: Offset(0, space_2),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(radius_2))),
                          onSelected: (item) => onSelected(context, item),
                          itemBuilder: (context) => [
                                ...MenuItems.listItem
                                    .map(showEachItemFromList)
                                    .toList(),
                              ]),
                ],
              ),
              LoadEndPointTemplate(
                  text: loadDetailsScreenModel.loadingPointCity,
                  endPointType: 'loading'),
              Container(
                height: space_4 + 2,
                padding: EdgeInsets.only(left: space_1 - 3),
                child: CustomPaint(
                  foregroundPainter: LinePainter(height: space_4 + 2, width: 1),
                ),
              ),
              LoadEndPointTemplate(
                  text: loadDetailsScreenModel.unloadingPointCity,
                  endPointType: 'unloading'),
              SizedBox(
                height: space_1,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Image(
                      image:
                          AssetImage('assets/images/TruckListEmptyImage.png'),
                      height: 24,
                      width: 24,
                    ),
                  ),
                  Text(
                    '${loadDetailsScreenModel.truckType} | ${loadDetailsScreenModel.noOfTyres} tyres',
                    style: TextStyle(
                        fontSize: size_6, fontWeight: mediumBoldWeight),
                  ),
                ],
              ),
              SizedBox(
                height: space_1,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Image(
                      image: AssetImage('assets/images/EmptyLoad.png'),
                      height: 24,
                      width: 24,
                    ),
                  ),
                  Text(
                    '${loadDetailsScreenModel.productType} | ${loadDetailsScreenModel.weight} tons',
                    style: TextStyle(
                        fontSize: size_6, fontWeight: mediumBoldWeight),
                  ),
                ],
              ),
              SizedBox(
                height: space_2,
              ),
              loadDetailsScreenModel.status == 'EXPIRED'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Load Expired!",
                          style: TextStyle(
                            color: declineButtonRed,
                            fontSize: size_8,
                            fontWeight: mediumBoldWeight,
                            fontFamily: 'montserrat',
                          ),
                        ),
                        RepostButton(),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        loadDetailsScreenModel.rate != 'NA'
                            ? PriceContainer(
                                rate: loadDetailsScreenModel.rate,
                                unitValue: loadDetailsScreenModel.unitValue,
                              )
                            : SizedBox(),
                        ViewBidsButton(
                          loadId: loadDetailsScreenModel.loadId,
                          loadingPointCity:
                              loadDetailsScreenModel.loadingPointCity,
                          unloadingPointCity:
                              loadDetailsScreenModel.unloadingPointCity,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<popupMenuforloads> showEachItemFromList(
          popupMenuforloads item) =>
      PopupMenuItem<popupMenuforloads>(
          value: item,
          child: Row(
            children: [
              Image(
                image: AssetImage(item.iconImage),
                height: size_6 + 1,
                width: size_6 + 1,
              ),
              SizedBox(
                width: space_1 + 2,
              ),
              Text(
                item.itemText,
                style: TextStyle(
                  fontWeight: mediumBoldWeight,
                  fontFamily: 'montserrat',
                ),
              ),
            ],
          ));

  void onSelected(BuildContext context, popupMenuforloads item) {
    ProviderData providerData =
        Provider.of<ProviderData>(context, listen: false);
    NavigationIndexController navigationIndexController =
        Get.find<NavigationIndexController>();
    switch (item) {
      case MenuItems.itemEdit:
        providerData.updateLoadingPointPostLoad(
            city: loadDetailsScreenModel.loadingPointCity!,
            state: loadDetailsScreenModel.loadingPointState!);
        providerData.updateUnloadingPointPostLoad(
            city: loadDetailsScreenModel.unloadingPointCity!,
            state: loadDetailsScreenModel.unloadingPointState!);
        providerData.updateProductType(loadDetailsScreenModel.productType);
        if (loadDetailsScreenModel.noOfTyres != "NA") {
          providerData
              .updateTruckNumber(int.parse(loadDetailsScreenModel.noOfTyres!));
        }
        providerData.updatePassingWeightValue(
            int.parse(loadDetailsScreenModel.weight!));
        providerData.updateTruckTypeValue(loadDetailsScreenModel.truckType!
            .replaceAll(" ", "_")
            .toUpperCase());

        if (loadDetailsScreenModel.unitValue == "tonne") {
          providerData.PerTonTrue(true, false);
        } else if (loadDetailsScreenModel.unitValue == "truck") {
          providerData.PerTruckTrue(true, false);
        } else {
          providerData.PerTonTrue(false, false);
          providerData.PerTruckTrue(false, false);
        }
        loadDetailsScreenModel.rate == "NA"
            ? providerData.updatePrice(0)
            : providerData.updatePrice(int.parse(loadDetailsScreenModel.rate!));
        providerData.updateBookingDate(loadDetailsScreenModel.loadDate);

        providerData.postLoadScreenOneButton();
        providerData.updateResetActive(true);
        providerData.updateEditLoad(true, loadDetailsScreenModel.loadId!);

        print(providerData.editLoad); // true
        Get.to(PostLoadScreenOne());
        break;
      case MenuItems.itemDisable:
        LoadApiCalls loadApiCalls = LoadApiCalls();
        loadApiCalls.disableActionOnLoad(loadId: loadDetailsScreenModel.loadId);
        Timer(Duration(seconds: 1), () {
          navigationIndexController.updateIndex(2);
          // Get.offAll(NavigationScreen());
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NavigationScreen()));
        });

        break;
    }
  }
}
