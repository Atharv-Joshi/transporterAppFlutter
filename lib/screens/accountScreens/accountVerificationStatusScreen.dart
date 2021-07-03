import 'package:flutter/material.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:flutter/cupertino.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/widgets/accountWidgets/accountDetailVerificationPending.dart';
import 'package:liveasy/widgets/accountWidgets/accountDetailVerified.dart';
import 'package:liveasy/widgets/accountWidgets/waitForReviewCard.dart';
import 'package:liveasy/widgets/buttons/helpButton.dart';
import 'package:liveasy/widgets/buyGpsLongWidget.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:get/get.dart';

class AccountVerificationStatusScreen extends StatelessWidget {
  final String mobileNum;
  final bool accountVerificationInProgress;

  AccountVerificationStatusScreen(
      {required this.mobileNum, required this.accountVerificationInProgress});

  @override
  Widget build(BuildContext context) {
    TransporterIdController transporterIdController =
        Get.find<TransporterIdController>();
    return Scaffold(
      backgroundColor: statusBarColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: space_2,
                      ),
                      HeadingTextWidget("My Account"),
                    ],
                  ),
                  HelpButtonWidget(),
                ],
              ),
              SizedBox(
                height: space_3,
              ),
              Container(
                height: 148,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(space_1 + 3),
                  color: darkBlueColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: space_3),
                      child: CircleAvatar(
                        radius: radius_11,
                        backgroundImage:
                            AssetImage("assets/images/defaultDriverImage.png"),
                      ),
                    ),
                    accountVerificationInProgress
                        ? AccountDetailVerificationPending(
                            mobileNum: mobileNum,
                          )
                        : AccountDetailVerified(
                            mobileNum: mobileNum,
                            name: transporterIdController.name.value,
                            companyName:
                                transporterIdController.companyName.value,
                            address: transporterIdController
                                .transporterLocation.value,
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: space_3,
              ),
              accountVerificationInProgress ? WaitForReviewCard() : Container(),
              accountVerificationInProgress
                  ? SizedBox(
                      height: space_3,
                    )
                  : Container(),
              BuyGpsLongWidget()
            ],
          ),
        ),
      ),
    );
  }
}
