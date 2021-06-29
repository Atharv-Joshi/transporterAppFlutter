import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/OKButtonCompletedDate.dart';
import 'package:liveasy/widgets/buttons/cancelCompletedDateButton.dart';

import '../completedTextField.dart';

class CompletedOrdersAlertDialog extends StatefulWidget {
  final String bookingId;
  CompletedOrdersAlertDialog({Key? key, required this.bookingId})
      : super(key: key);

  @override
  _CompletedOrdersAlertDialogState createState() =>
      _CompletedOrdersAlertDialogState();
}

class _CompletedOrdersAlertDialogState
    extends State<CompletedOrdersAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Completed Date",
                      style: TextStyle(
                          fontWeight: normalWeight,
                          fontSize: size_9,
                          color: liveasyBlackColor),
                    ),
                    SizedBox(
                      height: space_3,
                    ),
                    CompletedTextField()
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OkButtonCompletedDate(bookingId: widget.bookingId),
                  SizedBox(width: space_4),
                  CancelCompletedDateButton(),
                ],
              )
            ],
          )),
    );
  }
}
