import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

class OrderScreenNavigationBarButton extends StatelessWidget {
  final String text;
  final int value;
  final PageController pageController;

  OrderScreenNavigationBarButton({required this.text, required this.value , required this.pageController});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    return Container(
      child: TextButton(
        onPressed: () {
          providerData.updateUpperNavigatorIndex(value);
          pageController.jumpToPage(value);
        },
        child: Text(
          '$text',
          style: TextStyle(
            color: providerData.upperNavigatorIndex == value
                ? loadingPointTextColor
                : locationLineColor,
            fontWeight: normalWeight,
          ),
        ),
      ),
    );
  }
}
