// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:liveasy/constants/color.dart';
// import 'package:liveasy/constants/fontSize.dart';
// import 'package:liveasy/constants/fontWeights.dart';
// import 'package:liveasy/constants/raidus.dart';
// import 'package:liveasy/constants/spaces.dart';
// import 'package:liveasy/providerClass/providerData.dart';
// import 'package:liveasy/screens/TruckScreens/AddNewTruck/truckNumberRegistration.dart';
// import 'package:provider/provider.dart';
// class SelectTruckDropDownWidget extends StatefulWidget {
//
//   @override
//   _SelectTruckDropDownWidgetState createState() => _SelectTruckDropDownWidgetState();
// }
//
// class _SelectTruckDropDownWidgetState extends State<SelectTruckDropDownWidget> {
//   var temp_dropdownvalue2;
//   String? selectedTruckId;
//   String? selectedTransporterId;
//
//   // String? selectedTruckNo;
//   // String? selectedTruckApproved;
//   // String? selectedImei;
//   // String? selectedPassingWeight;
//   String? selectedDriverId;
//
//   // String? selectedTruckType;
//   // String? selectedTyres;
//   @override
//   Widget build(BuildContext context) {
//     var providerData = Provider.of<ProviderData>(context,listen: false);
//     return Column(children: [
//       Text(
//         "Select a Truck",
//         style: TextStyle(fontSize: size_9, fontWeight: normalWeight),
//       ),
//       SizedBox(
//         height: space_2,
//       ),
//       Container(
//         height: space_7 + 2,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(radius_4 + 2),
//             border: Border.all(color: borderLightColor)),
//         child: Padding(
//           padding: EdgeInsets.only(
//             left: space_2 - 2,
//             right: space_2 - 2,
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: providerData.dropdownvalue1,
//               icon: Icon(Icons.arrow_drop_down_circle_sharp),
//               iconEnabledColor: darkBlueColor,
//               style: TextStyle(
//                   fontSize: size_7,
//                   fontWeight: regularWeight,
//                   color: Colors.black),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   newValue == "Add Truck"
//                       ? Get.to(() => AddNewTruck())
//                       : providerData.updateDropDownValue1(
//                       newValue: newValue!);
//                   searchingDetailsFromTruckNo();
//                   providerData.updateDropDownValue2(
//                       newValue: temp_dropdownvalue2.toString());
//                 });
//               },
//               items: providerData.truckNoList
//                   .map<DropdownMenuItem<String>>((dynamic value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ),],);
//   }
//
//   void searchingDetailsFromTruckNo() {
//     final truckList = widget.truckDetailsList;
//     for (TruckModel item in truckList) {
//       if (Provider.of<ProviderData>(context)
//           .dropdownvalue1!
//           .compareTo(item.truckNo.toString()) ==
//           0) {
//         selectedTruckId = item.truckId.toString();
//         selectedTransporterId = item.transporterId.toString();
//         // widget.selectedTruckNo = item.truckNo.toString();
//         // widget.selectedTruckApproved = item.truckId.toString();
//         // widget.selectedImei = item.imei.toString();
//         // widget.selectedPassingWeight = item.passingWeight.toString();
//         selectedDriverId = item.driverId.toString();
//
//         temp_dropdownvalue2 =
//             getDriverNameFromDriverApi(item.driverId.toString());
//
//         // widget.selectedTruckType = item.truckType.toString();
//         // widget.selectedTyres = item.tyres.toString();
//         break;
//       }
//     }
//   }
// }
//
//
