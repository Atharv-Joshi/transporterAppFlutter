import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/responsive.dart';
import 'package:provider/provider.dart';

//This button is used to navigate through orders screen
class OrderScreenNavigationBarButton extends StatelessWidget {
  final String text;
  final int value;
  final PageController pageController;

  OrderScreenNavigationBarButton(
      {required this.text, required this.value, required this.pageController});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    //Here code for mobile and web is seperated by checking the screen size
    return Responsive.isMobile(context)
        ? Container(
            child: TextButton(
              onPressed: () {
                providerData.updateUpperNavigatorIndex(value);
                pageController.jumpToPage(value);
              },
              child: Text(
                '$text',
                style: GoogleFonts.montserrat(
                  color: providerData.upperNavigatorIndex == value
                      ? loadingPointTextColor
                      : locationLineColor,
                  fontWeight: normalWeight,
                ),
              ),
            ),
          )
        : Expanded(
            child: InkWell(
              hoverColor: transparent,
              onTap: () {
                if (pageController.page == value) {
                  if (pageController.page == 0) {
                    pageController
                        .nextPage(
                            duration: const Duration(milliseconds: 40),
                            curve: Curves.easeIn)
                        .whenComplete(() => pageController.previousPage(
                            duration: const Duration(milliseconds: 1),
                            curve: Curves.easeIn));
                  } else {
                    pageController
                        .previousPage(
                            duration: const Duration(milliseconds: 40),
                            curve: Curves.easeIn)
                        .whenComplete(() => pageController.nextPage(
                            duration: const Duration(milliseconds: 1),
                            curve: Curves.easeIn));
                  }
                } else {
                  pageController.jumpToPage(value);
                  providerData.updateUpperNavigatorIndex(value);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: GoogleFonts.montserrat(
                        color: providerData.upperNavigatorIndex == value
                            ? kLiveasyColor
                            : locationLineColor,
                        fontWeight: FontWeight.w600,
                        fontSize: size_10,
                      ),
                    ),
                  ),
                  Container(
                    height: 5,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: providerData.upperNavigatorIndex == value
                          ? kLiveasyColor
                          : locationLineColor,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
