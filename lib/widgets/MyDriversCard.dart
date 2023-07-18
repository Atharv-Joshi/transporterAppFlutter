import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/models/driverModel.dart';
import 'package:liveasy/models/popupModelForMyDrivers.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/alertDialog/editDriverAlertDialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'alertDialog/addDriverAlertDialog.dart';
import 'alertDialog/confirmDeleteDriverDialogBox.dart';
import 'buttons/callButton.dart';

class MyDriverCard extends StatefulWidget {
  late DriverModel driverData;

  MyDriverCard({
    required this.driverData,
  });

  @override
  _MyDriverCardState createState() => _MyDriverCardState();
}

class _MyDriverCardState extends State<MyDriverCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.driverData.driverName!.length > 15) {
      widget.driverData.driverName =
          widget.driverData.driverName!.substring(0, 14) + '..';
    }
    return Container(
      color: greyishWhiteColor,
      margin: EdgeInsets.only(bottom: space_2),
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(space_2),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(right: space_2),
                      height: space_5,
                      child: Image.asset('assets/icons/person.png')),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            '${widget.driverData.driverName}',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: size_7),
                          ),
                        ),
                        Container(
                          // alignment: Alignment.centerLeft,
                          child: Text(
                            '${widget.driverData.phoneNum}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CallButton(
                            directCall: true,
                            phoneNum: widget.driverData.phoneNum,
                          ),
                          PopupMenuButton<popupMenuforDrivers>(
                              offset: Offset(0, space_2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(radius_2))),
                              onSelected: (item) =>
                                  onSelected(context, item),
                              itemBuilder: (context) => [
                                ...menuItems.listItem
                                    .map(showEachItemFromList)
                                    .toList(),
                              ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<popupMenuforDrivers> showEachItemFromList(
      popupMenuforDrivers item) =>
      PopupMenuItem<popupMenuforDrivers>(
          value: item,
          child: Row(
            children: [
              Image(
                image: AssetImage(item.iconImage),
                height: size_6 + 1,
                width: size_6 + 1,
              ),
              SizedBox(
                width: space_1 + 2,
              ),
              Text(
                item.itemText,
                style: TextStyle(
                  fontWeight: mediumBoldWeight,
                  fontFamily: 'montserrat',
                ),
              ),
            ],
          ));

  void onSelected(BuildContext context, popupMenuforDrivers item) {
    switch (item) {
      case menuItems.itemDelete:
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return confirmDeleteDialogBox(
                driverData: widget.driverData,
              );
            });
        break;
      case menuItems.itemEdit:
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              print("${widget.driverData.id} -------- DRIVER DATA -------");
              return EditDriverAlertDialog(
                driverEditData: widget.driverData,
              );
            });
        break;
    }
  }
}
