
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:liveasy/widgets/addTrucksHeader.dart';
import 'package:liveasy/widgets/truckTypeButtontemplate.dart';

class TruckDescriptionScreen extends StatefulWidget {
  const TruckDescriptionScreen({Key? key}) : super(key: key);

  @override
  _TruckDescriptionScreenState createState() => _TruckDescriptionScreenState();
}

class _TruckDescriptionScreenState extends State<TruckDescriptionScreen> {

  List truckTypeList = ['Open Half Body' , 'Flatbed' , 'Open Full Body' ,
                        'Full Body Trailer' , 'Half Body Trailer' , 'Standard Container' ,
                        'High-Cube Container' , 'Tanker'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color:  backgroundColor,
              padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddTrucksHeader(),
                  AddTruckSubtitleText(text: 'Truck Type'),
                  GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 4,
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 10,
                    //physics:BouncingScrollPhysics(),
                    padding: EdgeInsets.all(10.0),
                      crossAxisCount: 2,
                      children: truckTypeList.map((e) => TruckTypeButtonTemplate(value: e, text: e)).toList(),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: space_2),
                      child: AddTruckSubtitleText(text: 'Passing Weight (in tons.)')
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
