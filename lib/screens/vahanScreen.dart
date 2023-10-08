import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../constants/spaces.dart';
import '../functions/ulipAPIs/vahanApis.dart';
import '../models/vahanApisModel.dart';
import '../widgets/buttons/helpButton.dart';
import '../widgets/vahanDetailsWidget.dart';

class VahanScreen extends StatefulWidget {
  final String? truckNo;
  VahanScreen({
    required this.truckNo,
  });

  @override
  State<VahanScreen> createState() => _VahanScreenState();
}

class _VahanScreenState extends State<VahanScreen> {
  VehicleDetails? _vehicleDetails;

  @override
  void initState() {
    super.initState();
    // Calling API function to fetch vehicle details here
    fetchVehicleDetails(widget.truckNo!).then((vehicleDetails) {
      setState(() {
        _vehicleDetails = vehicleDetails;
      });
    }).catchError((error) {
      // Handle the error, e.g., show an error message
      print("Error fetching vehicle details: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          '${widget.truckNo}',
          style: TextStyle(color: darkBlueColor, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 0,
        leading: Container(
          margin: EdgeInsets.all(space_2),
          child: CupertinoNavigationBarBackButton(
            color: darkBlueColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(space_2),
            child: HelpButtonWidget(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(space_3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_vehicleDetails ==
                  null) // Show circular progress indicator while loading
                Center(
                  child: CircularProgressIndicator(
                    color: darkBlueColor,
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Owner Name'),
                    Text(
                      '${_vehicleDetails?.ownerName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, space_1, 2, space_2),
                      child: Container(
                        color: black,
                        width: width,
                        height: 0.5,
                      ),
                    ),
                    // custom widget is used to display all the details
                    VahanDetailsWidget(
                      title1: 'Vehicle Model',
                      text1: '${_vehicleDetails?.vehicleModel}',
                      title2: 'Vehicle Maker',
                      text2: '${_vehicleDetails?.vehicleMaker}',
                      isText1Bold: true,
                    ),
                    VahanDetailsWidget(
                      title1: 'Vehicle Financer',
                      text1: '${_vehicleDetails?.vehicleFinancer}',
                      title2: 'Vehicle Class, Body Type',
                      text2: '${_vehicleDetails?.vehicleClass}',
                      text3: '${_vehicleDetails?.bodyType}',
                      isText1Bold: true,
                    ),
                    VahanDetailsWidget(
                        title1: 'RC Status',
                        text1: '${_vehicleDetails?.rcStatus}',
                        title2: 'Ownership',
                        text2: '${_vehicleDetails?.ownership}',
                        text1Color: shareButtonColor),
                    VahanDetailsWidget(
                      title1: 'RC Valid Upto',
                      text1: '${_vehicleDetails?.rcValidUpto}',
                      title2: 'RC Issue Date',
                      text2: '${_vehicleDetails?.rcIssueDate}',
                    ),
                    VahanDetailsWidget(
                      title1: 'Pollution Cert Valid Upto',
                      text1: '${_vehicleDetails?.pollutionCertValidUpto}',
                      title2: 'Pollution Cert No',
                      text2: '${_vehicleDetails?.pollutionCertNo}',
                    ),
                    VahanDetailsWidget(
                      title1: 'Insurance Valid Upto',
                      text1: '${_vehicleDetails?.insuranceValidUpto}',
                      title2: 'Insurance Policy No',
                      text2: '${_vehicleDetails?.insurancePolicyNo}',
                    ),
                    VahanDetailsWidget(
                      title1: 'Permit Type',
                      text1: '${_vehicleDetails?.permitType}',
                      title2: 'Permit No',
                      text2: '${_vehicleDetails?.permitNumber}',
                    ),
                    VahanDetailsWidget(
                      title1: 'Permit Valid Upto',
                      text1: '${_vehicleDetails?.permitValidUpto}',
                      title2: 'Permit Issue Date',
                      text2: '${_vehicleDetails?.permitIssueDate}',
                    ),
                    VahanDetailsWidget(
                      title1: 'Seat Capacity',
                      text1: '${_vehicleDetails?.seatCapacity}',
                      isText1Bold: true,
                      title2: 'Engine Capacity',
                      text2: '${_vehicleDetails?.engineCapacity}',
                    ),
                    VahanDetailsWidget(
                      title1: 'Fuel Type',
                      text1: '${_vehicleDetails?.fuelType}',
                      isText1Bold: true,
                      title2: 'Fuel Norms',
                      text2: '${_vehicleDetails?.fuelNorms}',
                    ),
                    VahanDetailsWidget(
                      title1: 'Vehicle Color',
                      text1: '${_vehicleDetails?.vehicleColor}',
                      title2: 'Unloaded(खाली) Weight',
                      text2: '${_vehicleDetails?.unloadedWeight}',
                    ),
                    VahanDetailsWidget(
                      title1: 'Engine No',
                      text1: '${_vehicleDetails?.engineNumber}',
                      title2: 'Chasis No',
                      text2: '${_vehicleDetails?.chassisNumber}',
                    ),
                    VahanDetailsWidget(
                      title1: 'Registration Authority',
                      text1: '${_vehicleDetails?.registeredAuthority}',
                      title2: 'Tax Valid Upto',
                      text2: '${_vehicleDetails?.taxValidUpto}',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
