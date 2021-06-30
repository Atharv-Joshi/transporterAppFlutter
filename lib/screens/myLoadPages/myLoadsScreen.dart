import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/models/loadApiModel.dart';
import 'package:liveasy/widgets/MyLoadsCard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http ;
import 'package:flutter_config/flutter_config.dart';

class MyLoadsScreen extends StatefulWidget {
  @override
  _MyLoadsScreenState createState() => _MyLoadsScreenState();
}

class _MyLoadsScreenState extends State<MyLoadsScreen> {

  List<LoadApiModel> myLoadList = [];

  final String loadApiUrl =  FlutterConfig.get("loadApiUrl");

  ScrollController scrollController = ScrollController();

  TransporterIdController transporterIdController = Get.find<TransporterIdController>();

  int i = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDataByPostLoadId(i);

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        getDataByPostLoadId(i + 1);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.67,
        child: myLoadList.length == 0
        ?
        Container(
          margin: EdgeInsets.only(top: 153),
          child: Column(
            children: [
              Image(
                image: AssetImage(
                    'assets/images/EmptyLoad.png'),
                height: 127,
                width: 127,
              ),
              Text(
                'Looks like you have not added any Loads!',
                style: TextStyle(fontSize: size_8, color: grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            :
             ListView.builder(
                itemCount: myLoadList.length,
                  itemBuilder: (context , index){


                      return MyLoadsCard(
                        loadId: myLoadList[index].loadId,
                        loadingPointCity: myLoadList[index].loadingPointCity,
                        unloadingPointCity: myLoadList[index]
                            .unloadingPointCity,
                        truckType: myLoadList[index].truckType,
                        weight: myLoadList[index].weight,
                        productType: myLoadList[index].productType,
                        rate: myLoadList[index].rate,
                        unitValue: myLoadList[index].unitValue,
                        loadDate: myLoadList[index].loadDate,
                        noOfTrucks: myLoadList[index].noOfTrucks,
                      );

                  }
              )
    );
  }


  // Future<List<LoadScreenCardsModel>>
  getDataByPostLoadId(int i) async {

    http.Response response = await  http.get(Uri.parse('$loadApiUrl?postLoadId=${transporterIdController.transporterId.value}&pageNo=$i'));

    var jsonData = json.decode(response.body);

    for( var json in jsonData){
      LoadApiModel loadScreenCardsModel = LoadApiModel();
      loadScreenCardsModel.loadId = json['loadId'];
      loadScreenCardsModel.loadingPointCity = json['loadingPointCity'] != null ?  json['loadingPointCity'] : 'NA' ;
      loadScreenCardsModel.unloadingPointCity = json['unloadingPointCity'] != null ?  json['unloadingPointCity'] : 'NA' ;
      loadScreenCardsModel.truckType = json['truckType'] != null ?  json['truckType'] : 'NA' ;
      loadScreenCardsModel.weight = json['weight'] != null ?  json['weight'] : 'NA' ;
      loadScreenCardsModel.productType = json['productType'] != null ?  json['productType'] : 'NA' ;
      loadScreenCardsModel.rate = json['rate'] ;
      loadScreenCardsModel.unitValue = json['unitValue'] != null ?  json['unitValue'] : 'NA' ;
      loadScreenCardsModel.noOfTrucks = json['noOfTrucks'] != null ?  json['noOfTrucks'] : 'NA' ;
      print(loadScreenCardsModel.noOfTrucks);
      loadScreenCardsModel.loadDate = json['loadDate'] != null ?  json['loadDate'] : 'NA' ;
      print('load Date is :  ${loadScreenCardsModel.loadDate}');

      setState(() {
        myLoadList.add(loadScreenCardsModel);
      });

    }
  }//builder
}//class end
