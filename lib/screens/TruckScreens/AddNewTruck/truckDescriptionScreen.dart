
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/addTruckCircularButtonTemplate.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:liveasy/widgets/addTrucksHeader.dart';
import 'package:liveasy/widgets/addTruckRectangularButtontemplate.dart';

class TruckDescriptionScreen extends StatefulWidget {
  const TruckDescriptionScreen({Key? key}) : super(key: key);

  @override
  _TruckDescriptionScreenState createState() => _TruckDescriptionScreenState();
}

class _TruckDescriptionScreenState extends State<TruckDescriptionScreen> {

  List truckTypeList = ['Open Half Body' , 'Flatbed' , 'Open Full Body' ,
                        'Full Body Trailer' , 'Half Body Trailer' , 'Standard Container' ,
                        'High-Cube Container' , 'Tanker'];

  List passingWeightList = [6,8,12,16,18,24,26,28,30];

  List totalTyresList = [6,8,10,12,16,18,24,26,28,30];

  List truckLengthList = [10,20,40,50,60];

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
                      children: truckTypeList.map((e) => AddTruckRectangularButtonTemplate(value: e, text: e)).toList(),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: space_2),
                      child: AddTruckSubtitleText(text: 'Passing Weight (in tons.)')
                  ),
                  // AddTruckCircularButtonTemplate(value: 30, text: 30),
                  // AddTruckCircularButtonTemplate(value: 28, text: 28)
                  GridView.count(
                    shrinkWrap: true,
                    // childAspectRatio: 1,
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 10,
                    //physics:BouncingScrollPhysics(),
                    padding: EdgeInsets.all(10.0),
                    crossAxisCount: 6,
                    children: passingWeightList.map((e) => AddTruckCircularButtonTemplate(value: e, text: e , category: 'weight',)).toList(),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: space_2),
                      child: AddTruckSubtitleText(text: 'Total Tyres (front & rear)')
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    // childAspectRatio: 1,
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 10,
                    //physics:BouncingScrollPhysics(),
                    padding: EdgeInsets.all(10.0),
                    crossAxisCount: 6,
                    children: totalTyresList.map((e) => AddTruckCircularButtonTemplate(value: e, text: e , category: 'tyres',)).toList(),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: space_2),
                      child: AddTruckSubtitleText(text: 'Truck Length (in ft)')
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    // childAspectRatio: 1,
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 10,
                    //physics:BouncingScrollPhysics(),
                    padding: EdgeInsets.all(10.0),
                    crossAxisCount: 6,
                    children: truckLengthList.map((e) => AddTruckCircularButtonTemplate(value: e, text: e , category: 'length',)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
