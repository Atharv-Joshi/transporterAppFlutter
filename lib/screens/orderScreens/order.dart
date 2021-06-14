import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/LoadCard.dart';

// ignore: camel_case_types
class order extends StatefulWidget {
  @override
  _orderState createState() => _orderState();
}

class _orderState extends State<order> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: EdgeInsets.only(top: space_10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: space_4),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: liveasyBlackColor,
                    ),
                    SizedBox(width: size_7),
                    Text(
                      "Orders",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size_10,
                          color: liveasyBlackColor,
                          fontFamily: "Montserrat"),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: space_4, left: space_4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Loads",
                      style: TextStyle(
                          fontWeight: normalWeight,
                          fontSize: size_7,
                          color: liveasyBlackColor,
                          fontFamily: "Montserrat"),
                    ),
                    Text(
                      "On-going",
                      style: TextStyle(
                          fontWeight: normalWeight,
                          fontSize: size_7,
                          color: liveasyBlackColor,
                          fontFamily: "Montserrat"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: space_4),
                      child: Text(
                        "Delivered",
                        style: TextStyle(
                            fontWeight: normalWeight,
                            fontSize: size_7,
                            color: liveasyBlackColor,
                            fontFamily: "Montserrat"),
                      ),
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
      ),
    );
  }
}
