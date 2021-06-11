import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//constants
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/addTruckButton.dart';
//widgets
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/helpButtonWidget.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:liveasy/widgets/myTrucksCard.dart';
import 'package:liveasy/widgets/searchLoadWidget.dart';
//functions
import 'package:liveasy/functions/truckApiCalls.dart';

class MyTrucks extends StatefulWidget {

  @override
  _MyTrucksState createState() => _MyTrucksState();
}

class _MyTrucksState extends State<MyTrucks> {

  TruckApiCalls truckApiCalls = TruckApiCalls();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: space_3,
                      ),
                      HeadingTextWidget("My Trucks"),
                      // HelpButtonWidget(),
                    ],
                  ),
                  HelpButtonWidget(),
                ],
              ),
              Container(
                  margin: EdgeInsets.symmetric(
                    vertical: space_3
                      ),
                  child: SearchLoadWidget(hintText: 'Search' , onPressed: () {} , )
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.67,
                child: FutureBuilder(
                  future: truckApiCalls.getTruckData(),
                  builder: (BuildContext context , AsyncSnapshot snapshot){
                    if(snapshot.data == null){
                      return LoadingWidget();
                    }
                    print('snapshot length :' + '${snapshot.data.length}');
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                        itemBuilder: (context , index){
                            return MyTruckCard(
                              truckId: snapshot.data[index].truckId,
                              transporterId:  snapshot.data[index].transporterId,
                              truckNo:  snapshot.data[index].truckNo,
                              truckApproved:  snapshot.data[index].truckApproved,
                              imei:  snapshot.data[index].imei,
                              passingWeight:  snapshot.data[index].passingWeight,
                              driverId:  snapshot.data[index].driverId,
                              truckType:  snapshot.data[index].truckType,
                              tyres:  snapshot.data[index].tyres
                            );
                        });
                  },
                ),
              ),
              //TODO: placement of add truck button and determine optimum length of listview container
              Container(
                  child: AddTruckButton()),
            ],
          ),
        ),
      ),
    );
  }


}
