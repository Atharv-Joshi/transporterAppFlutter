import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/buttons/bidButtonSendRequest.dart';
import 'package:liveasy/widgets/buttons/cancelButton.dart';
import 'package:provider/provider.dart';

enum RadioButtonOptions { PER_TON, PER_TRUCK }

// ignore: must_be_immutable
class BidButtonAlertDialog extends StatefulWidget {
  String? loadId;
  String? bidId;
  bool? isPost;

  BidButtonAlertDialog({this.loadId, this.bidId, required this.isPost});

  @override
  _BidButtonAlertDialogState createState() => _BidButtonAlertDialogState();
}

class _BidButtonAlertDialogState extends State<BidButtonAlertDialog> {

  RadioButtonOptions unitValue = RadioButtonOptions.PER_TON;


  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    return AlertDialog(
      insetPadding: EdgeInsets.only(left: space_4, right: space_4),
      title: Text(
        "Please enter your rate",
        style: TextStyle(fontSize: size_9, fontWeight: normalWeight),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Radio<RadioButtonOptions>(
                      value: RadioButtonOptions.PER_TON,
                      activeColor: darkBlueColor,
                      groupValue: unitValue,
                      onChanged: (value) {
                        setState(() {
                          unitValue = value!;
                        });
                      }),
                  Text(
                    "Per Tonne",
                    style: TextStyle(
                        fontWeight: mediumBoldWeight,
                        fontSize: size_7,
                        color: darkBlueColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio<RadioButtonOptions>(
                      value: RadioButtonOptions.PER_TRUCK,
                      activeColor: darkBlueColor,
                      groupValue: unitValue,
                      onChanged: (value) {
                        setState(() {
                          unitValue = value!;
                        });
                      }),
                  Text(
                    "Per Truck",
                    style: TextStyle(
                        fontWeight: mediumBoldWeight,
                        fontSize: size_7,
                        color: darkBlueColor),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: darkGreyColor)),
            child: Padding(
              padding: EdgeInsets.only(
                left: space_2 - 2,
                right: space_2 - 2,
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                // controller: rate,
                decoration: InputDecoration(
                  hintText: "Eg 4000",
                  hintStyle: TextStyle(color: textLightColor),
                  border: InputBorder.none,
                ),
                onChanged: (String? rate) {
                  if (rate == null || rate == "") {
                    providerData.updateBidButtonSendRequest(false);
                  } else {
                    //TODO: bug: if we change unt value without changing rate then previous unitValue will be passed
                    providerData.updateRate(rate , unitValue.toString());
                    providerData.updateBidButtonSendRequest(true);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(top: space_16 + 6, bottom: space_4 + 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BidButtonSendRequest(
                loadId: widget.loadId ,
                bidId: widget.bidId,
                isPost: widget.isPost,
              ),
              CancelButton()
            ],
          ),
        )
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius_2 - 2)),
      ),
    );
  }
}
