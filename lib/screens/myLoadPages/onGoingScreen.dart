import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/bookingApiCalls.dart';
import 'package:liveasy/functions/loadOnGoingDeliveredData.dart';
import 'package:liveasy/models/BookingModel.dart';
import 'package:liveasy/widgets/loadingWidget.dart';
import 'package:liveasy/widgets/onGoingCard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

class OngoingScreen extends StatefulWidget {

    final  navBarHeight;
    OngoingScreen({this.navBarHeight});
    @override
    _OngoingScreenState createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {

    //for counting page numbers
    int i = 0;

    TransporterIdController transporterIdController = Get.find<TransporterIdController>();

    final String bookingApiUrl = FlutterConfig.get('bookingApiUrl');

    List<BookingModel> modelList = [];

    ScrollController scrollController = ScrollController();

    getDataByPostLoadIdOnGoing(int i) async {

        // modelList = [];
        http.Response response = await http.get(Uri.parse('$bookingApiUrl?postLoadId=${transporterIdController.transporterId.value}&completed=false&cancel=false&pageNo=$i'));


        var jsonData = json.decode(response.body);

        for (var json in jsonData) {

            BookingModel bookingModel = BookingModel(truckId: []);

            bookingModel.bookingDate =
            json['bookingDate'] != null ? json['bookingDate'] : "NA";

            bookingModel.loadId = json['loadId'];

            bookingModel.transporterId = json['transporterId'];

            bookingModel.truckId = json['truckId'];

            bookingModel.cancel = json['cancel'];

            bookingModel.completed = json['completed'];

            bookingModel.completedDate =
            json['completedDate'] != null ? json['completedDate'] : "NA";

            setState(() {
                modelList.add(bookingModel);
            });

        }



    }

    @override
    void initState() {

        super.initState();

        getDataByPostLoadIdOnGoing(i);

        scrollController.addListener(() {
            if (scrollController.position.pixels ==  scrollController.position.maxScrollExtent) {
                getDataByPostLoadIdOnGoing(i + 1);
            }
        });
    }

    @override
    void dispose() {

        scrollController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.67,
            // child: FutureBuilder(
            //     future: bookingApiCalls.getDataByPostLoadIdOnGoing(),
            //     builder: (BuildContext context, AsyncSnapshot snapshot) {
            //
            //         if (snapshot.data == null) {
            //             return LoadingWidget();
            //         }
            //         print('ongoing snapshot length :' +
            //             '${snapshot.data.length}'); //number of cards
            //
            //         if (snapshot.data.length == 0) {
            //             return Container(
            //                 margin: EdgeInsets.only(top: 153),
            //                 child: Column(
            //                     children: [
            //                         Image(
            //                             image: AssetImage(
            //                                 'assets/images/EmptyLoad.png'),
            //                             height: 127,
            //                             width: 127,
            //                         ),
            //                         Text(
            //                             'Looks like you have not added any Loads!',
            //                             style: TextStyle(fontSize: size_8, color: grey),
            //                             textAlign: TextAlign.center,
            //                         ),
            //                     ],
            //                 ),
            //             );
            //         }
            //         else {
            //             return ListView.builder(
            child: modelList.length == 0
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
            //     : ListView.builder(
            //     // itemCount: snapshot.data.length,
            //     controller: scrollController,
            //     itemCount: modelList.length,
            //     itemBuilder: (context, index)  {
            //
            //         // return FutureBuilder(
            //         //     future: loadAllData(modelList[index]) ,
            //         //     builder: (BuildContext context,
            //         //         AsyncSnapshot snapshot) {
            //         //         if (snapshot.data == null) {
            //         //             // return LoadingWidget();
            //         //             return SizedBox();
            //         //         }
            //         //
            //         //         // return OngoingCard(
            //         //         //     loadingPoint: snapshot.data['loadingPoint'],
            //         //         //     unloadingPoint: snapshot.data['unloadingPoint'],
            //         //         //     companyName: snapshot.data['companyName'],
            //         //         //     truckNo: snapshot.data['truckNo'],
            //         //         //     driverName: snapshot.data['driverName'],
            //         //         //     startedOn: snapshot.data['startedOn'],
            //         //         //     endedOn: snapshot.data['endedOn'],
            //         //         //     imei: snapshot.data['imei'],
            //         //         //     driverPhoneNum: snapshot.data['driverPhoneNum'],
            //         //         //     transporterPhoneNumber: snapshot.data['transporterPhoneNum'],
            //         //         //     // transporterName : snapshot.data['transporterName'],
            //         //         // );
            //         //         return Text('on going card');
            //         //     }
            //         //
            //         // );
            //         return Text('Future builder');
            //
            //
            //     } //builder
            //
            // )
            : Text('list view builder')
            // } //else
        );
    }
}//class end


