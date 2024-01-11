import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/providerClass/providerData.dart';
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

    return Expanded(
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
                style: TextStyle(
                  color: providerData.upperNavigatorIndex == value
                      ? kLiveasyColor
                      : locationLineColor,
                  fontWeight: FontWeight.w600,
                  fontSize: size_8,
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
