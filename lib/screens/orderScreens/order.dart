import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/Loadwidget.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/suggestedLoadsWidget.dart';

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
                    SizedBox(width: 15),
                    Text(
                      "Orders",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
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
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: liveasyBlackColor,
                          fontFamily: "Montserrat"),
                    ),
                    Text(
                      "On-going",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: liveasyBlackColor,
                          fontFamily: "Montserrat"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: space_4),
                      child: Text(
                        "Delivered",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: liveasyBlackColor,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                height: 10,
                color: Color(0xff979797),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  left: 20,
                  right: 20,
                ),
                child: Loadwidget(
                  loadFrom: "Jabalpur",
                  loadTo: "Jalandhar",
                  trucktype: "Flatbed",
                  tyres: 20,
                  Weight: 20,
                  producttype: "paint",
                  load: 6000,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  left: 20,
                  right: 20,
                ),
                child: Loadwidget(
                  loadFrom: "Alwar",
                  loadTo: "Jalandhar",
                  trucktype: "Flatbed",
                  tyres: 16,
                  Weight: 15,
                  producttype: "paint",
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
