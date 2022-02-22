import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/getImageFromCamera.dart';
import 'package:liveasy/widgets/accountVerification/roundedImageDisplay.dart';

// ignore: must_be_immutable
class IdInputWidget extends StatelessWidget {
  var providerData;

  IdInputWidget({this.providerData});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
          padding: EdgeInsets.all(space_3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "addAddressProof".tr,
                style: TextStyle(
                  fontWeight: mediumBoldWeight,
                  fontSize: size_8,
                ),
              ),
              Text(
                "docsExample".tr,
                style: TextStyle(fontSize: size_6, color: grey),
              ),
              SizedBox(
                height: space_2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundedImageDisplay(
                    text: "idFront".tr,
                    onPressed: () async {
                      showPicker(
                          providerData.updateAddressProofFrontPhoto,
                          providerData.updateAddressProofFrontPhotoStr,
                          context);
                    },
                    imageFile: providerData.addressProofFrontPhotoFile,
                  ),
                  RoundedImageDisplay(
                    text: "idBack".tr,
                    onPressed: () async {
                      showPicker(providerData.updateAddressProofBackPhoto,
                          providerData.updateAddressProofBackPhotoStr, context);
                    },
                    imageFile: providerData.addressProofBackPhotoFile,
                  ),
                ],
              ),
              SizedBox(
                height: space_3,
              ),
              Text(
                "addId".tr,
                style: TextStyle(
                    fontSize: size_8,
                    color: veryDarkGrey,
                    fontWeight: mediumBoldWeight),
              ),
              Text(
                "addIdExample".tr,
                style: TextStyle(fontSize: size_6, color: grey),
              ),
              SizedBox(
                height: space_3,
              ),
              Center(
                child: RoundedImageDisplay(
                  text: "panFront".tr,
                  onPressed: () async {
                    showPicker(providerData.updatePanFrontPhoto,
                        providerData.updatePanFrontPhotoStr, context);
                  },
                  imageFile: providerData.panFrontPhotoFile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
