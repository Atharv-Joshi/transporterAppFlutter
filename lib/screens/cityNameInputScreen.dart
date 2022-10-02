import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/mmiUtils/autoFillMMI.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/autoFillDataDisplayCard.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/textFieldWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';

class CityNameInputScreen extends StatefulWidget {
  final String valueType;

  CityNameInputScreen(this.valueType);

  @override
  _CityNameInputScreenState createState() => _CityNameInputScreenState();
}

class _CityNameInputScreenState extends State<CityNameInputScreen> {
  @override
  void initState() {
    super.initState();
    getMMIToken();
  }

  var locationCard;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double keyboardLength = MediaQuery.of(context).viewInsets.bottom;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: space_4),
          child: ListView(
            children: [
              SizedBox(
                height: space_6,
              ),
              Container(
                child: Row(
                  children: [
                    BackButtonWidget(),
                    SizedBox(
                      width: space_2,
                    ),
                    Expanded(
                      // child: CustomTextField(
                      //   hintText: "Select starting point",
                      //   textController: controller,
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => MapBoxAutoCompleteWidget(
                      //           apiKey: "pk.eyJ1IjoiZ2Fydml0YTkzNiIsImEiOiJjbDg0ZWNwZXkwMmJmM3ZwNWFzbnJpcXNlIn0.8WpvYsCUf889t6-nGoc4cA",
                      //           hint: "Select starting point",
                      //           onSelect: (place) {
                      //             // TODO : Process the result gotten
                      //             controller.text = place.placeName!;
                      //           },
                      //           limit: 10,
                      //           country: "IN",
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   enabled: true,
                      // ),

                      child: TextFieldWidget(
                          onChanged: (String value) {
                            setState(() {
                              locationCard = fillCityName(value);    //return auto suggested places using MapMyIndia api
                            });
                          },
                          controller: controller,
                          hintText: 'enterCityName'.tr
                          // AppLocalizations.of(context)!.enterCityName,
                          ),

                    ),
                  ],
                ),
              ),
              locationCard == null
                  ? Container()
                  : SizedBox(
                      height: space_4,
                    ),
              locationCard != null
                  ? Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: keyboardLength != 0
                          ? screenHeight - keyboardLength - 130
                          : screenHeight - 130, //TODO: to be modified
                      child: FutureBuilder(
                          future: locationCard,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return Container();
                            }
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              reverse: false,
                              padding: EdgeInsets.symmetric(
                                horizontal: space_2,
                              ),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) =>
                                  AutoFillDataDisplayCard(
                                      snapshot.data[index].placeCityName,
                                      snapshot.data[index].placeStateName, () {
                                if (widget.valueType == "Loading Point") {
                                  Provider.of<ProviderData>(context,
                                          listen: false)
                                      .updateLoadingPointFindLoad(
                                          city: snapshot
                                              .data[index].placeCityName,
                                          state: snapshot
                                              .data[index].placeStateName);
                                  Get.back();
                                } else if (widget.valueType ==
                                    "Unloading Point") {
                                  Provider.of<ProviderData>(context,
                                          listen: false)
                                      .updateUnloadingPointFindLoad(
                                          city: snapshot
                                              .data[index].placeCityName,
                                          state: snapshot
                                              .data[index].placeStateName);
                                  // Get.off(FindLoadScreen());
                                  Get.back();
                                } else if (widget.valueType ==
                                    "Loading point") {
                                  Provider.of<ProviderData>(context,
                                          listen: false)
                                      .updateLoadingPointPostLoad(
                                          city: snapshot
                                              .data[index].placeCityName,
                                          state: snapshot
                                              .data[index].placeStateName);
                                  Get.back();
                                } else if (widget.valueType ==
                                    "Unloading point") {
                                  Provider.of<ProviderData>(context,
                                          listen: false)
                                      .updateUnloadingPointPostLoad(
                                          city: snapshot
                                              .data[index].placeCityName,
                                          state: snapshot
                                              .data[index].placeStateName);
                                  Get.back();
                                }
                              }),
                            );
                          }),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
