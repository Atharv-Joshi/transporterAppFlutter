import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/PostLoadApi.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import 'package:get/get.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:provider/provider.dart';

class ApplyButton extends StatelessWidget {
  const ApplyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoadApi loadApi = LoadApi();
    TransporterIdController transporterIdController =
        Get.find<TransporterIdController>();
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: space_20,
          height: space_8,
          margin: EdgeInsets.fromLTRB(space_8, space_4, space_8, space_0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(space_10),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: providerData.postLoadScreenTwoButton()
                      ? activeButtonColor
                      : deactiveButtonColor,
                ),
                child: Text(
                  'Apply',
                  style: TextStyle(
                    color: white,
                  ),
                ),
                onPressed: () {
                  providerData.updateUnitValue();

                  if (providerData.postLoadScreenTwoButton()) {
                    loadApi.postLoadAPi(
                        providerData.bookingDate,
                        transporterIdController.transporterId.value,
                        " ${providerData.loadingPointCityPostLoad},${providerData.loadingPointStatePostLoad}",
                        providerData.loadingPointCityPostLoad,
                        providerData.loadingPointStatePostLoad,
                        providerData.truckNumber,
                        providerData.productType,
                        providerData.truckTypeValue,
                        " ${providerData.unloadingPointCityPostLoad},${providerData.unloadingPointStatePostLoad}",
                        providerData.unloadingPointCityPostLoad,
                        providerData.unloadingPointStatePostLoad,
                        providerData.passingWeightValue,
                        providerData.unitValue == ""
                            ? null
                            : providerData.unitValue,
                        providerData.price == 0 ? null : providerData.price);
                    providerData.resetTruckFilters();
                    providerData.resetPostLoadScreenOne();
                    controller.text = "";
                    controllerOthers.text = "";
                    Get.snackbar("Posted Successfully", "message");
                  } else {
                    return null;
                  }
                  providerData.updateIndex(2);
                  Get.offAll(() => NavigationScreen());


                }),
          ),
        ),
      ],
    );
  }
}
