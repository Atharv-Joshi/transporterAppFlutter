import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/LoadCard.dart';
import 'package:liveasy/widgets/OrderSectionTitleName.dart';
import 'package:liveasy/widgets/OrderTitleTextWidget.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';

// ignore: camel_case_types
class order extends StatefulWidget {
  @override
  _orderState createState() => _orderState();
}

class _orderState extends State<order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: space_10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: space_4),
              child: Row(
                children: [
                  BackButtonWidget(),
                  SizedBox(width: space_3),
                  OrderTitleTextWidget(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: space_4, left: space_4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OrderSectionTitleName(name: 'My Loads'),
                  OrderSectionTitleName(name: 'On_going'),
                  Padding(
                    padding: EdgeInsets.only(right: space_4),
                    child: OrderSectionTitleName(name: 'Delivered'),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: size_5,
              color: Color(0xff979797),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: size_7,
                left: size_10,
                right: size_10,
              ),
              child: LoadCard(
                loadFrom: "Jabalpur",
                loadTo: "Jalandhar",
                truckType: "Flatbed",
                tyres: 20,
                weight: 20,
                productType: "paint",
                load: 6000,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: size_7,
                left: size_10,
                right: size_10,
              ),
              child: LoadCard(
                loadFrom: "Alwar",
                loadTo: "Jalandhar",
                truckType: "Flatbed",
                tyres: 16,
                weight: 15,
                productType: "paint",
                load: 8000,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
