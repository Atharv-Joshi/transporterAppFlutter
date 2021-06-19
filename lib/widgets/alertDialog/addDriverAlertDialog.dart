import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/addButton.dart';
import 'package:liveasy/widgets/buttons/cancelButton.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:contact_picker/contact_picker.dart';

class AddDriverAlertDialog extends StatefulWidget {
  @override
  _AddDriverAlertDialogState createState() => _AddDriverAlertDialogState();
}

class _AddDriverAlertDialogState extends State<AddDriverAlertDialog> {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
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
            "ADD DRIVER NAME",
            style: TextStyle(fontSize: size_9, fontWeight: normalWeight),
          ),
          SizedBox(
            height: space_2,
          ),
          Container(
            height: space_7 + 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderLightColor)),
            child: Padding(
              padding: EdgeInsets.only(
                left: space_2 - 2,
                right: space_2 - 2,
              ),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  hintText: contactName != "" ? contactName : "",
                  hintStyle:
                      TextStyle(color: black, fontWeight: mediumBoldWeight),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: space_2 + 2,
          ),
          Text(
            "ADD CONTACT NO",
            style: TextStyle(fontSize: size_9, fontWeight: normalWeight),
          ),
          SizedBox(
            height: space_2,
          ),
          Container(
            height: space_7 + 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: borderLightColor)),
            child: Padding(
              padding: EdgeInsets.only(
                left: space_2 - 2,
                right: space_2 - 2,
              ),
              child: TextField(
                controller: number,
                decoration: InputDecoration(
                  hintText: contactNumber != "" ? contactNumber : "",
                  hintStyle:
                      TextStyle(color: black, fontWeight: mediumBoldWeight),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: space_4 - 2, bottom: space_1 - 2),
                child: Text(
                  "OR",
                  style: TextStyle(fontSize: size_7, fontWeight: normalWeight),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: space_4 + 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () async {
                      print(name.text);
                      print(number.text);
                      if (await Permission.contacts.request().isGranted) {
                        Contact contact = await _contactPicker.selectContact();
                        setState(() {
                          _contact = contact;
                          contactName = _contact!.fullName.toString();
                          contactNumber =
                              _contact!.phoneNumber.number.toString();
                          displayContact =
                              contactName! + " - " + contactNumber!;
                        });
                      }
                    },
                    child: Icon(
                      Icons.add,
                      color: truckGreen,
                    )),
                Text(
                  "Select From Your Contact List  ",
                  style: TextStyle(fontSize: size_7, fontWeight: normalWeight),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(top: space_11, bottom: space_4 + 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AddButton(
                  displayContact: displayContact,
                  name: name.text,
                  number: number.text),
              CancelButton()
            ],
          ),
        )
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius_2 - 2)),
      ),
      insetPadding: EdgeInsets.only(left: space_4, right: space_4),
    );
  }
}
