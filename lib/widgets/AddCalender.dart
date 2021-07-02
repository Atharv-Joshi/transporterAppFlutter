import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

class AddCalender extends StatefulWidget {
  final String text;
  final String value;
  bool selected = false;
  AddCalender({Key? key, required this.text, required this.value})
      : super(key: key);

  @override
  _AddCalenderState createState() => _AddCalenderState();
}

class _AddCalenderState extends State<AddCalender> {
  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      child: OutlinedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(2),
            backgroundColor: providerData.bookingDate == widget.value
                ? MaterialStateProperty.all(darkBlueColor)
                : MaterialStateProperty.all(whiteBackgroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ))),
        child: Text(
          widget.text,
          style: TextStyle(
              fontWeight: normalWeight,
              fontSize: widget.text == 'High-Cube Container' ||
                      widget.text == 'Standard Container'
                  ? size_6
                  : size_7,
              color: providerData.bookingDate == widget.text ? white : black),
        ),
        onPressed: () {
          providerData.updateResetActive(true);
          providerData.updateBookingDate(widget.value);
        },
      ),
    );
  }
}
