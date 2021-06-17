import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//constants
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/driverApiCalls.dart';
import 'package:liveasy/models/truckModel.dart';
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
  
  DriverApiCalls driverApiCalls = DriverApiCalls();

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

                            TruckModel truckModel = TruckModel(truckApproved: false);

                            truckModel.truckId =  snapshot.data[index].truckId;
                            truckModel.transporterId =   snapshot.data[index].transporterId;
                            truckModel.truckNo =  snapshot.data[index].truckNo;
                            truckModel.truckApproved =  snapshot.data[index].truckApproved;
                            truckModel.imei =  snapshot.data[index].imei;
                            truckModel.passingWeight =  snapshot.data[index].passingWeight;
                            truckModel.driverId =  snapshot.data[index].driverId;
                            truckModel.truckType =  snapshot.data[index].truckType;
                            truckModel.tyres =  snapshot.data[index].tyres;

                              return FutureBuilder(
                                future: driverApiCalls.getDriverByDriverId(truckModel : truckModel),
                                  builder: (BuildContext context , AsyncSnapshot snapshot){
                                    if(snapshot.data == null){
                                      return LoadingWidget();
                                    }
                                    return MyTruckCard(
                                        truckApproved: snapshot.data.truckApproved,
                                        truckNo : snapshot. data.truckNo,
                                        truckType: snapshot.data.truckType,
                                        tyres: snapshot.data.tyres,
                                        driverName : snapshot.data.driverName,
                                        phoneNum:  snapshot.data.driverNum,
                                         );

                                  }

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
