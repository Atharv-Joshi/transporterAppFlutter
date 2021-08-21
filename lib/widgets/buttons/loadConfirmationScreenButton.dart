import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/postLoadErrorController.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/PostLoadApi.dart';
import 'package:liveasy/functions/PutLoadAPI.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenLoacationDetails.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:liveasy/widgets/alertDialog/loadingAlertDialog.dart';
import 'package:liveasy/widgets/alertDialog/CompletedDialog.dart';
import 'package:liveasy/widgets/alertDialog/orderFailedAlertDialog.dart';
import 'package:provider/provider.dart';

class LoadConfirmationScreenButton extends StatelessWidget {
  String title;
  LoadConfirmationScreenButton({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // LoadApi loadApi = LoadApi();
    PostLoadErrorController postLoadErrorController =
        Get.put(PostLoadErrorController());
    TransporterIdController transporterIdController =
        Get.find<TransporterIdController>();
    ProviderData providerData = Provider.of<ProviderData>(context);

    getData() async {
      String? loadId = '';
      if (loadId == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return LoadingAlertDialog();
          },
        );
      }
      if(providerData.editLoad == false){
        loadId = await postLoadAPi(
            providerData.bookingDate,
            transporterIdController.transporterId.value,
            "${providerData.loadingPointCityPostLoad}, ${providerData.loadingPointStatePostLoad}",
            providerData.loadingPointCityPostLoad,
            providerData.loadingPointStatePostLoad,
            providerData.truckNumber,
            providerData.productType,
            providerData.truckTypeValue,
            "${providerData.unloadingPointCityPostLoad}, ${providerData.unloadingPointStatePostLoad}",
            providerData.unloadingPointCityPostLoad,
            providerData.unloadingPointStatePostLoad,
            providerData.passingWeightValue,
            providerData.unitValue == "" ? null : providerData.unitValue,
            providerData.price == 0 ? null : providerData.price);

        if (loadId != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return completedDialog(
                upperDialogText: "Congratulations!",
                lowerDialogText: "You have completed your order!",
              );
            },
          );
          Timer(
              Duration(seconds: 3),
                  () => {
                providerData.updateIndex(2),
                Get.offAll(() => NavigationScreen()),
                providerData.resetPostLoadFilters(),
                providerData.resetPostLoadScreenOne(),
                controller.text = "",
                controllerOthers.text = ""
              });
          providerData.updateEditLoad(true, "");
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return OrderFailedAlertDialog();
            },
          );
        }
      }
      else if(providerData.editLoad == true) {
        loadId = await putLoadAPI(
            providerData.transporterLoadId,
            providerData.bookingDate,
            transporterIdController.transporterId.value,
            "${providerData.loadingPointCityPostLoad}, ${providerData.loadingPointStatePostLoad}",
            providerData.loadingPointCityPostLoad,
            providerData.loadingPointStatePostLoad,
            providerData.truckNumber,
            providerData.productType,
            providerData.truckTypeValue,
            "${providerData.unloadingPointCityPostLoad}, ${providerData.unloadingPointStatePostLoad}",
            providerData.unloadingPointCityPostLoad,
            providerData.unloadingPointStatePostLoad,
            providerData.passingWeightValue,
            providerData.unitValue == "" ? null : providerData.unitValue,
            providerData.price == 0 ? null : providerData.price);

        if (loadId != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return completedDialog(
                upperDialogText: "Congratulations!",
                lowerDialogText: "You have successfully updated the load!",
              );
            },
          );
          Timer(
              Duration(seconds: 3),
                  () => {
                providerData.updateIndex(2),
                Get.offAll(() => NavigationScreen()),
                providerData.resetPostLoadFilters(),
                providerData.resetPostLoadScreenOne(),
                controller.text = "",
                controllerOthers.text = ""
              });
          providerData.updateEditLoad(false, "");
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return OrderFailedAlertDialog();
            },
          );
        }
      }
    }

    return GestureDetector(
      onTap: () {
        // title=="Edit"?Get.to(PostLoadScreenOne()):
        if (title == "Edit") {
          Get.to(PostLoadScreenOne());
        } else {
          providerData.updateUnitValue();
          getData();
        }
      },
      child: Container(
        height: space_8,
        decoration: BoxDecoration(
            color: darkBlueColor,
            borderRadius: BorderRadius.circular(radius_6)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: white, fontWeight: mediumBoldWeight, fontSize: size_8),
          ),
        ),
      ),
    );
  }
}
