import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/loadOnGoingDeliveredData.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/buttons/addButton.dart';
import 'package:liveasy/widgets/buttons/cancelButton.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:contact_picker/contact_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddDriverAlertDialog extends StatefulWidget {
  @override
  _AddDriverAlertDialogState createState() => _AddDriverAlertDialogState();
}

class _AddDriverAlertDialogState extends State<AddDriverAlertDialog> {
  TextEditingController driverNameController = TextEditingController();
  TextEditingController driverNumberController = TextEditingController();
  final ContactPicker _contactPicker = new ContactPicker();
  Contact? _contact;
  String? contactName;
  String? contactNumber;
  String displayContact = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Driver’s Name",
            style: TextStyle(
                fontSize: size_9,
                fontWeight: normalWeight,
                color: liveasyBlackColor),
          ),
          SizedBox(
            height: space_2,
          ),
          Container(
            height: space_7 + 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius_4 + 2),
                border: Border.all(color: darkGreyColor)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: space_2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: driverNameController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: "Type here",
                        hintStyle: TextStyle(
                            color: textLightColor,
                            fontSize: size_8,
                            fontWeight: regularWeight),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        print(driverNameController.text);
                        print(driverNumberController.text);
                        if (await Permission.contacts.request().isGranted) {
                          Contact contact =
                              await _contactPicker.selectContact();
                          setState(() {
                            _contact = contact;
                            print(_contact);
                            contactName = _contact!.fullName.toString();
                            driverNameController = TextEditingController(
                                text: _contact!.fullName.toString());
                            contactNumber =
                                _contact!.phoneNumber.number.contains("+91") ? _contact!.phoneNumber.number.replaceRange(0, 3, "").replaceAll(new RegExp(r"\D"), ""):_contact!.phoneNumber.number.toString().replaceAll(new RegExp(r"\D"), "");
                            print(contactNumber);
                            driverNumberController = TextEditingController(
                                text: contactNumber);
                            displayContact =
                                contactName! + " - " + contactNumber!;
                          });
                        }
                      },
                      child: Image(
                        image:
                            AssetImage("assets/icons/addFromPhoneBookIcon.png"),
                        height: space_5 + 2,
                        width: space_5 + 2,
                      )),
                ],
              ),
            ),
            //   ],),
            // child: ListTile(
            //   title: Padding(
            //     padding: EdgeInsets.only(
            //       left: space_2 - 2,
            //       right: space_2 - 2,
            //     ),
            //     child: TextField(
            //       controller: name,
            //       decoration: InputDecoration(
            //         hintText: contactName != "" ? contactName : "",
            //         hintStyle:
            //             TextStyle(color: black, fontWeight: mediumBoldWeight),
            //         border: InputBorder.none,
            //       ),
            //     ),
            //   ),
            //   trailing: GestureDetector(
            //       onTap: () async {
            //         print(name.text);
            //         print(number.text);
            //         if (await Permission.contacts.request().isGranted) {
            //           Contact contact = await _contactPicker.selectContact();
            //           setState(() {
            //             _contact = contact;
            //             contactName = _contact!.fullName.toString();
            //             contactNumber = _contact!.phoneNumber.number.toString();
            //             displayContact = contactName! + " - " + contactNumber!;
            //           });
            //         }
            //       },
            //       child: Image(
            //         image: AssetImage("assets/icons/addFromPhoneBookIcon.png"),
            //         height: space_5+2,
            //         width: space_5+2,
            //       )),
            //   isThreeLine: false,
            // ),
          ),
          SizedBox(
            height: space_2 + 2,
          ),
          Text(
            "Driver's Number",
            style: TextStyle(
                fontSize: size_9,
                fontWeight: normalWeight,
                color: liveasyBlackColor),
          ),
          SizedBox(
            height: space_2,
          ),
          Container(
            height: space_7 + 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius_4 + 2),
                border: Border.all(color: darkGreyColor)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: space_2),
              child: TextField(
                controller: driverNumberController,
                decoration: InputDecoration(
                  hintText: "Type here",
                  hintStyle: TextStyle(
                      color: textLightColor,
                      fontSize: size_8,
                      fontWeight: regularWeight),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AddButton(
              name: driverNameController.text,
              number: driverNumberController.text,
              onTap: () {
                // print("name--" + "$name");
                // providerData.updateDriverNameList(newValue: displayContact);

                if(driverNumberController.text.length == 10){
                  TransporterIdController tIdController = Get.find<TransporterIdController>();
                  Provider.of<ProviderData>(context,listen: false).updateDropDownValue2(newValue: "driverNameController.text - driverNumberController.text");
                  String transporterId = '${tIdController.transporterId}';
                  driverApiCalls.postDriverApi(
                      driverNameController.text, driverNumberController.text, transporterId);
                  Navigator.of(context).pop();}
                else{Get.snackbar("Error", "Enter a valid 10 digit number");}
              },
            ),
            CancelButton()
          ],
        )
      ],
      contentPadding:
          EdgeInsets.symmetric(horizontal: space_3, vertical: space_4),
      actionsPadding: EdgeInsets.only(top: space_8, bottom: space_3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius_2 - 2)),
      ),
      insetPadding: EdgeInsets.only(left: space_4, right: space_4),
    );
  }
}
