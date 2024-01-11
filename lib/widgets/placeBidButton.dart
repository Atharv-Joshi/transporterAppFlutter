import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color.dart';
import '../constants/radius.dart';
import '../constants/spaces.dart';
import '../controller/transporterIdController.dart';
import 'alertDialog/bidButtonAlertDialog.dart';
import 'alertDialog/verifyAccountNotifyAlertDialog.dart';

class PlaceBidButton extends StatelessWidget {
  final String? loadId;
  final String? loadingPointCity;
  final String? unloadingPointCity;
  final String? postLoadId;
  PlaceBidButton(
      {required this.loadId,
      required this.loadingPointCity,
      required this.unloadingPointCity,
      required this.postLoadId});

  @override
  Widget build(BuildContext context) {
    TransporterIdController tIdController = Get.find<TransporterIdController>();
    return GestureDetector(
      onTap: () async {
        if (tIdController.transporterApproved.value) {
          await showDialog(
              context: context,
              builder: (context) => BidButtonAlertDialog(
                    isNegotiating: false,
                    isPost: true,
                    loadId: loadId,
                    loadingPoint: loadingPointCity,
                    unloadingPoint: unloadingPointCity,
                    postLoadId: postLoadId,
                  ));
        } else {
          showDialog(
              context: context,
              builder: (context) => VerifyAccountNotifyAlertDialog());
        }
      },
      child: Container(
        height: space_9,
        width: space_50,
        decoration: BoxDecoration(
            color: darkBlueColor,
            borderRadius: BorderRadius.circular(radius_1)),
        child: Center(
          child: Text(
            'Place Bid',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: white,
            ),
          ),
        ),
      ),
    );
  }
}
