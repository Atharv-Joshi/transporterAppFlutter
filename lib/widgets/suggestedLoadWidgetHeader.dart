import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/screens/SuggestedLoadsScreen.dart';

class SuggestedLoadWidgetHeader extends StatelessWidget {
  const SuggestedLoadWidgetHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'suggestedLoad'.tr,
          // AppLocalizations.of(context)!.suggestedLoad,
          style: TextStyle(
              color: liveasyBlackColor,
              fontFamily: 'montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Get.to(() => SuggestedLoadScreen());
          },
          child: Text(
            'seeAll'.tr,
            // AppLocalizations.of(context)!.seeAll,
            style: TextStyle(
                color: liveasyGreen,
                fontFamily: 'montserrat',
                fontWeight: FontWeight.bold,
                fontSize: size_8),
          ),
        ),
      ],
    );
  }
}
