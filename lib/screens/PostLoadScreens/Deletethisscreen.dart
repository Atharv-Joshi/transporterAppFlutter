import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/PostLoadApi.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class D extends StatefulWidget {
  const D({Key? key}) : super(key: key);

  @override
  _DState createState() => _DState();
}

class _DState extends State<D> {
  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    TransporterIdController transporterIdController =
        Get.find<TransporterIdController>();
    LoadApi loadApi = LoadApi();
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(providerData.loadingPointCityPostLoad),
            Text(providerData.unloadingPointCityPostLoad),
            Text(providerData.truckNumber.toString()),
            Text(providerData.passingWeightValue.toString()),
            Text(providerData.truckTypeValue),
            Text(providerData.productType),
            Text(transporterIdController.transporterId.value),
            Text(providerData.unitValue),
            Text(providerData.price.toString()),
            ElevatedButton(
                onPressed: () {
                  providerData.postLoadScreenTwoButton()
                      ? loadApi.postLoadAPi(
                          providerData.bookingDate,
                          transporterIdController.transporterId.value,
                          "abc",
                          providerData.loadingPointCityPostLoad,
                          providerData.loadingPointStatePostLoad,
                          providerData.truckNumber,
                          providerData.productType,
                          providerData.truckTypeValue,
                          "unloadingPoint",
                          providerData.unloadingPointCityPostLoad,
                          providerData.unloadingPointStatePostLoad,
                          providerData.passingWeightValue,
                          providerData.unitValue,
                          providerData.price)
                      : null;
                },
                child: Text("Post Load"))
          ],
        ),
      ),
    );
  }
}
