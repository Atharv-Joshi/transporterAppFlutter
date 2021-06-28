import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenOne.dart';
import 'package:liveasy/widgets/LoadCard.dart';
import 'package:liveasy/widgets/OrderSectionTitleName.dart';
import 'package:liveasy/widgets/alertDialog/verifyAccountNotifyAlertDialog.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:get/get.dart';
import 'package:liveasy/widgets/onGoingCard.dart';

// ignore: camel_case_types
class order extends StatefulWidget {
  @override
  _orderState createState() => _orderState();
}

class _orderState extends State<order> {
  @override
  Widget build(BuildContext context) {
    TransporterIdController transporterIdController =
        Get.find<TransporterIdController>();
    return SingleChildScrollView(
      child: Stack(children: [
        Column(
          children: [
            LoadCard(
              loadFrom: "Jabalpur",
              loadTo: "Jalandhar",
              truckType: "Flatbed",
              tyres: 20,
              weight: 20,
              productType: "paint",
              load: 6000,
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.17,
              bottom: space_7,
              child: Container(
                height: space_8,
                margin: EdgeInsets.fromLTRB(space_8, space_4, space_8, space_0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(space_10),
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: activeButtonColor),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          space_8,
                          space_2,
                          space_8,
                          space_2,
                        ),
                        child: Text(
                          'Post load',
                          style: TextStyle(
                              color: white,
                              fontWeight: mediumBoldWeight,
                              fontSize: size_8),
                        ),
                      ),
                      onPressed: () {
                        transporterIdController.transporterApproved.value &&
                                transporterIdController.companyApproved.value
                            ? Get.to(PostLoadScreenOne())
                            : showDialog(
                                context: context,
                                builder: (context) =>
                                    VerifyAccountNotifyAlertDialog());
                      }),
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
