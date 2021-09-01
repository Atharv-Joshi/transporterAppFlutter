import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/postLoadVariablesController.dart';
import 'package:liveasy/widgets/LoadConfirmationTemplate.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/buttons/loadConfirmationScreenButton.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/loadLabelValueRowTemplate.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';

class LoadConfirmation extends StatefulWidget {
  const LoadConfirmation({Key? key}) : super(key: key);

  @override
  _LoadConfirmationState createState() => _LoadConfirmationState();
}

class _LoadConfirmationState extends State<LoadConfirmation> {
  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    providerData.updateUnitValue();
    // providerData.updateLoadWidget(true);
    PostLoadVariablesController postLoadVariables = Get.find<PostLoadVariablesController>();
    return Scaffold(
      backgroundColor: statusBarColor,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(space_2),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: space_4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: space_2),
                              child: BackButtonWidget(),
                            ),
                            SizedBox(
                              width: space_3,
                            ),
                            HeadingTextWidget("Load Confirmation"),
                            // HelpButtonWidget(),
                          ],
                        ),
                        SizedBox(
                          height: space_4,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: space_3),
                          child: Text(
                            "Review details for your load",
                            style: TextStyle(
                                fontSize: size_9,
                                fontWeight: mediumBoldWeight,
                                color: liveasyBlackColor),
                          ),
                        ),
                        SizedBox(
                          height: space_4,
                        ),
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                space_3, space_2, space_3, space_3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: LoadConfirmationTemplate(
                                      value:
                                      "${providerData.loadingPointCityPostLoad}, ${providerData.loadingPointStatePostLoad} ==> ${providerData.unloadingPointCityPostLoad}, ${providerData.unloadingPointStatePostLoad}",
                                      label: 'Location'),
                                ),
                                LoadConfirmationTemplate(
                                    value: postLoadVariables.bookingDate.value,
                                    label: 'Date'),
                                LoadConfirmationTemplate(
                                    value: providerData.truckTypeValue,
                                    label: 'Truck Type'),
                                LoadConfirmationTemplate(
                                    value: providerData.truckNumber.toString(),
                                    label: 'No.Of Trucks'),
                                LoadConfirmationTemplate(
                                    value: providerData.passingWeightValue
                                        .toString(),
                                    label: 'Weight'),
                                LoadConfirmationTemplate(
                                    value: providerData.productType,
                                    label: 'Product Type'),
                                LoadConfirmationTemplate(
                                    value: providerData.price == 0
                                        ? "Price Not Given"
                                        : "Rs.${providerData.price}/${providerData.unitValue}",
                                    label: 'Price'),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: space_6),
                    child: Padding(
                      padding: EdgeInsets.only(left: space_8, right: space_8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child:
                              LoadConfirmationScreenButton(title: 'Edit')),
                          SizedBox(
                            width: space_10,
                          ),
                          Expanded(
                              child: LoadConfirmationScreenButton(
                                  title: 'Confirm')),
                        ],
                      ),
                    ),
                  )

                  // HelpButtonWidget(),
                ],
              ),
            )),
      ),
    );
  }
}