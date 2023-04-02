import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/variables/truckFilterVariablesForPostLoad.dart';
import 'package:liveasy/widgets/PostLoadScreenTwoSearch.dart';
import 'package:liveasy/widgets/PriceTextFieldWidget.dart';
import 'package:liveasy/widgets/UnitValueWidget.dart';
import 'package:liveasy/widgets/addPostLoadHeader.dart';
import 'package:liveasy/widgets/addTruckCircularButtonTemplate.dart';
import 'package:liveasy/widgets/addTruckRectangularButtontemplate.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:liveasy/widgets/buttons/ApplyButton.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/constants/spaces.dart';

import '../../constants/fontSize.dart';

class PostLoadScreenTwo extends StatefulWidget {
  const PostLoadScreenTwo({Key? key}) : super(key: key);

  @override
  _PostLoadScreenTwoState createState() => _PostLoadScreenTwoState();
}

TextEditingController controller = TextEditingController();
TextEditingController controllerOthers = TextEditingController();

List<int> numberOfTyresList = [6, 10, 12, 14, 16, 18, 22, 26];
List<int> weightList = [6, 8, 12, 14, 18, 24, 26, 28, 30, 0];
TruckFilterVariablesForPostLoad truckFilterVariables =
    TruckFilterVariablesForPostLoad();

class _PostLoadScreenTwoState extends State<PostLoadScreenTwo> {
  @override
  Widget build(BuildContext context) {
    bool visible = false;
    ProviderData providerData = Provider.of<ProviderData>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(space_2, space_4, space_2, space_0),
                  child: AddPostLoadHeader(
                    reset: true,
                    resetFunction: () {
                      setState(() {
                        controller.text = "";
                        controllerOthers.text = "";
                        providerData.resetTruckFilters();
                        providerData.updatePrice(0);
                        providerData.PerTonTrue(false, false);
                        providerData.updateBorderColor(darkBlueColor);
                        providerData.updateTotalTyresValue(0);
                        providerData.resetOnNewType();
                        providerData.clearProductType();
                        providerData.updateResetActive(false);
                      });
                    },
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(space_4, space_4, space_4, space_4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AddTruckSubtitleText(text: 'truckType'.tr
                            // "Truck Type"
                            ),
                        SizedBox(height: space_2),
                        GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          childAspectRatio: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          padding: EdgeInsets.all(10.0),
                          crossAxisCount: 2,
                          children: truckFilterVariables.truckTypeValueList
                              .map((e) => AddTruckRectangularButtonTemplate(
                                  value: e,
                                  text: truckFilterVariables.truckTypeTextList[
                                      truckFilterVariables.truckTypeValueList
                                          .indexOf(e)]))
                              .toList(),
                        ),
                        SizedBox(height: space_3),
                        AddTruckSubtitleText(text: 'tyres'.tr
                            // "Tyres(chakka)"
                            ),
                        SizedBox(height: space_2),
                        Padding(
                          padding: EdgeInsets.only(
                            left: space_2,
                            right: space_2,
                          ),
                          child: Container(
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 6,
                              children: numberOfTyresList
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AddTruckCircularButtonTemplate(
                                          value: e,
                                          text: e != 0 ? e.toString() : "+",
                                          category: 'tyres',
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: space_2),
                        AddTruckSubtitleText(text: 'productType'.tr
                            // "Product Type"
                            ),
                        SizedBox(height: space_2),
                        PostLoadScreenTwoSearch(hintText: 'chooseproductType'.tr
                            // "Choose Product Type"
                            ),
                        SizedBox(height: space_3),
                        AddTruckSubtitleText(text: 'weights'.tr
                            // "Weight(in tons)"
                            ),
                        SizedBox(height: space_2),
                        providerData.truckTypeValue == ''
                            ? SizedBox()
                            : Container(
                                child: GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 6,
                                  children: truckFilterVariables
                                      .passingWeightList[
                                          providerData.truckTypeValue]!
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:
                                                AddTruckCircularButtonTemplate(
                                              value: e,
                                              text: e != 0 ? e.toString() : "+",
                                              category: 'weight',
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                        SizedBox(height: space_3),
                        providerData.pluspressed==true?Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: priceBackground,
                                    offset: Offset.fromDirection(0.8),
                                    spreadRadius: 1)
                              ],
                              shape: BoxShape.circle,
                              border: Border(
                                  top: BorderSide(width: 1, color: grey),
                                  right: BorderSide(width: 1, color: grey),
                                  left: BorderSide(width: 1, color: grey),
                                  bottom: BorderSide(width: 1, color: grey)),
                            ),
                            child: CircleAvatar(
                              backgroundColor: darkBlueColor,
                              child: Text(
                                '${providerData.passingWeightValue}',
                                style: TextStyle(
                                    fontSize: size_10,
                                    color: white),
                              ),
                            ),
                          ),
                        ):Container(),
                        SizedBox(height: space_3),
                        AddTruckSubtitleText(text: 'priceoptional'.tr
                            // "Price(Optional)"
                            ),
                        SizedBox(height: space_2),
                        UnitValueWidget(),
                        SizedBox(height: space_3),
                        PriceTextFieldWidget(),
                        SizedBox(height: space_3),
                        // SizedBox(height: space_18),
                        ApplyButton(),
                        SizedBox(height: space_18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
