import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/hudController.dart';
import 'package:liveasy/controller/navigationIndexController.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/documentApi/postAccountVerificationDocuments.dart';
import 'package:liveasy/functions/trasnporterApis/updateTransporterApi.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:liveasy/widgets/accountVerification/companyIdInputWidget.dart';
import 'package:liveasy/widgets/accountVerification/elevatedButtonWidget.dart';
import 'package:liveasy/widgets/alertDialog/conflictDialog.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AccountVerificationPage2 extends StatelessWidget {
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  HudController hudController = Get.put(HudController());

  @override
  Widget build(BuildContext context) {
    NavigationIndexController navigationIndexController =
        Get.find<NavigationIndexController>();
    var providerData = Provider.of<ProviderData>(context);
    return Scaffold(
      backgroundColor: statusBarColor,
      body: SafeArea(
          child: Obx(
        () => ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
          ),
          inAsyncCall: hudController.showHud.value,
          child: Container(
            padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          BackButtonWidget(),
                          SizedBox(
                            width: space_3,
                          ),
                          HeadingTextWidget("my_account".tr),
                        ],
                      ),
                      HelpButtonWidget(),
                    ],
                  ),
                  SizedBox(
                    height: space_4,
                  ),
                  Row(
                    children: [
                      Text(
                        "forPostingLoad".tr,
                        style: TextStyle(
                            fontSize: size_9,
                            color: liveasyBlackColor,
                            fontWeight: mediumBoldWeight),
                      ),
                      Text(
                        "optional".tr,
                        style: TextStyle(
                            fontSize: size_9, color: liveasyBlackColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: space_5,
                  ),
                  CompanyIdInputWidget(
                    providerData: providerData,
                  ),
                  ElevatedButtonWidget(
                      condition: true,
                      text: "verify".tr,
                      onPressedConditionTrue: () async {
                        hudController.updateHud(true);
                        await postAccountVerificationDocuments(
                                profilePhoto: providerData.profilePhoto64,
                                addressProofFront:
                                    providerData.addressProofFrontPhoto64,
                                addressProofBack:
                                    providerData.addressProofBackPhoto64,
                                panFront: providerData.panFrontPhoto64,
                                companyIdProof:
                                    providerData.companyIdProofPhoto64)
                            .then((uploadstatus) async {
                          if (uploadstatus == "Success") {
                            final status = await updateTransporterApi(
                                accountVerificationInProgress: true,
                                verificationType: 'Manual',
                                transporterApproved:false,
                                transporterId: transporterIdController
                                    .transporterId.value);
                            if (status == "Success") {
                              hudController.updateHud(false);
                              Get.offAll(NavigationScreen());
                              // providerData.updateIndex(4);
                            } else {
                              hudController.updateHud(false);
                              showDialog(
                                  context: context,
                                  builder: (context) => ConflictDialog(
                                      dialog: "Failed Please try again"));
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => ConflictDialog(
                                    dialog: "Failed Please try again"));
                          }
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
