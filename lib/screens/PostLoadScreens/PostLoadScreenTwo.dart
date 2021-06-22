import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/PostLoadApi.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/PostLoadScreens/Deletethisscreen.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
import 'package:liveasy/widgets/PostLoadScreenTwoSearch.dart';
import 'package:liveasy/widgets/addPostLoadHeader.dart';
import 'package:liveasy/widgets/addTruckCircularButtonTemplate.dart';
import 'package:liveasy/widgets/addTruckRectangularButtontemplate.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class PostLoadScreenTwo extends StatefulWidget {
  const PostLoadScreenTwo({Key? key}) : super(key: key);

  @override
  _PostLoadScreenTwoState createState() => _PostLoadScreenTwoState();
}

TextEditingController controller1 = TextEditingController();
TextEditingController controller2 = TextEditingController();

class _PostLoadScreenTwoState extends State<PostLoadScreenTwo> {
  LoadApi loadApi = LoadApi();
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();
  List<int> numberOfTrucksList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> weightList = [6, 8, 12, 14, 18, 24, 26, 28, 30];

  TruckFilterVariables truckFilterVariables = TruckFilterVariables();
  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.fromLTRB(space_2, space_4, space_2, space_0),
                child: AddPostLoadHeader(
                  reset: true,
                  resetFunction: () {
                    providerData.resetTruckFilters();
                    providerData.updateResetActive(false);
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
                      AddTruckSubtitleText(text: "Truck Type"),
                      SizedBox(height: space_2),
                      GridView.count(
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
                      AddTruckSubtitleText(text: "Number of Trucks"),
                      SizedBox(height: space_2),
                      Padding(
                        padding: EdgeInsets.only(
                          left: space_2,
                          right: space_2,
                        ),
                        child: Container(
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 6,
                            children: numberOfTrucksList
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AddTruckCircularButtonTemplate(
                                        value: e,
                                        text: e,
                                        category: 'Number',
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: space_3),
                      AddTruckSubtitleText(text: "Weight(in tons)"),
                      SizedBox(height: space_2),
                      Padding(
                        padding: EdgeInsets.only(
                          left: space_2,
                          right: space_2,
                        ),
                        child: Container(
                          child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 6,
                            children: weightList
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AddTruckCircularButtonTemplate(
                                        value: e,
                                        text: e,
                                        category: 'weight',
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: space_2),
                      AddTruckSubtitleText(text: "Product Type"),
                      SizedBox(height: space_2),
                      PostLoadScreenTwoSearch(hintText: "Choose Product Type"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: space_20,
                            height: space_8,
                            margin: EdgeInsets.fromLTRB(
                                space_8, space_4, space_8, space_0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(space_10),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        providerData.postLoadScreenTwoButton()
                                            ? activeButtonColor
                                            : deactiveButtonColor,
                                  ),
                                  child: Text(
                                    'Apply',
                                    style: TextStyle(
                                      color: white,
                                    ),
                                  ),
                                  onPressed: () {
                                    providerData.postLoadScreenTwoButton()
                                        ? loadApi.postLoadAPi(
                                            providerData.bookingDate,
                                            transporterIdController
                                                .transporterId.value,
                                            "abc",
                                            providerData
                                                .loadingPointCityPostLoad,
                                            providerData
                                                .loadingPointStatePostLoad,
                                            providerData.truckNumber,
                                            providerData.productType,
                                            providerData.truckTypeValue,
                                            "unloadingPoint",
                                            providerData
                                                .unloadingPointCityPostLoad,
                                            providerData
                                                .unloadingPointStatePostLoad,
                                            providerData.passingWeightValue)
                                        : null;
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
