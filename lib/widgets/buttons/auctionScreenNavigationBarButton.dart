import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/controller/postLoadVariablesController.dart';
import 'package:provider/provider.dart';

import '/constants/fontWeights.dart';
import '/providerClass/providerData.dart';

class AuctionScreenNavigationBarButton extends StatelessWidget {
  final String text;
  final int value;
  final PageController pageController;

  PostLoadVariablesController postLoadVariables =
      Get.put(PostLoadVariablesController());

  AuctionScreenNavigationBarButton(
      {required this.text, required this.value, required this.pageController});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.4,
      height: screenHeight * 0.06,
      decoration: BoxDecoration(
          color: providerData.upperNavigatorIndex == value
              ? bidBackground
              : unselectedGrey,
          borderRadius: BorderRadius.circular(5)),
      child: TextButton(
        onPressed: () {
          providerData.updateUpperNavigatorIndex(value);
          pageController.jumpToPage(value);
        },
        child: Text(
          '$text',
          style: GoogleFonts.montserrat(
            color: white,
            fontSize: size_9,
            fontWeight: mediumBoldWeight,
          ),
        ),
      ),
    );
  }
}
