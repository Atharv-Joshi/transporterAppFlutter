import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:get/get.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenLoacationDetails.dart';

// ignore: must_be_immutable
class PostButtonLoad extends StatelessWidget {
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 163,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(liveasyGreen),
        ),
        onPressed: () {
          transporterIdController.companyApproved.value
              ? Get.to(PostLoadScreenOne())
              : showDialog(
                  context: context,
                  builder: (context) => VerifyAccountNotifyAlertDialog());
        },
        child: Container(
          child: Text(
            'Post Load',
            style: TextStyle(
              fontWeight: mediumBoldWeight,
              color: white,
              fontSize: size_8,
            ),
          ),
        ),
      ),
    );
  }
}
