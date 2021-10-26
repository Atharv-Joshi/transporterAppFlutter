import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import 'package:provider/provider.dart';

class OkButtonProductType extends StatefulWidget {
  late String category;

  OkButtonProductType({Key? key, required this.category}) : super(key: key);

  @override
  State<OkButtonProductType> createState() => _OkButtonProductTypeState();
}

class _OkButtonProductTypeState extends State<OkButtonProductType> {
  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      width: space_16,
      height: space_6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(space_10),
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: activeButtonColor),
          onPressed: () {
            if (controllerOthers.text.length > 0) {
              int data = int.parse(controllerOthers.text);
              switch (widget.category) {
                case 'weight':
                  providerData.updatePassingWeightValue(
                      controllerOthers.text == ""
                          ? "Choose Product Weight"
                          : data);
                  setState(() {
                    //weightList.remove(0);
                    if (!truckFilterVariables
                        .passingWeightList[providerData.truckTypeValue]!
                        .contains(data)) {
                      truckFilterVariables
                          .passingWeightList[providerData.truckTypeValue]!
                          .insert(
                              truckFilterVariables
                                      .passingWeightList[
                                          providerData.truckTypeValue]!
                                      .length -
                                  1,
                              data);
                    }
                  });
                  break;
                case 'tyres':
                  providerData.updateTotalTyresValue(controllerOthers.text == ""
                      ? "Choose Product Tyres"
                      : data);
                  setState(() {
                    // weightList.remove(0);
                    // numberOfTyresList.add(data);
                    if (!numberOfTyresList.contains(data)) {
                      numberOfTyresList.insert(
                          numberOfTyresList.length - 1, data);
                    }
                  });
                  break;
                case 'length':
                  providerData.updateTruckLengthValue(
                      controllerOthers.text == ""
                          ? "Choose Product Length"
                          : data);
                  break;
                case 'Type':
                  providerData.updateProductType(controllerOthers.text == ""
                      ? "Choose Product Type"
                      : controllerOthers.text);
                  Get.back();
                  break;
                default:
                  print("something went wrong in ok button");
                  break;
              }
              controllerOthers.clear();
              Get.back();
            } else {
              Get.back();
              Get.defaultDialog(
                  title: "please enter Product ${widget.category} to continue");
            }
          },
          child: Text(
            'OK',
            style: TextStyle(
              fontSize: size_6,
            ),
          ),
        ),
      ),
    );
  }
}
