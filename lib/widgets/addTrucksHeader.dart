import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';

// ignore: must_be_immutable
class AddTrucksHeader extends StatefulWidget {

  final dynamic resetFunction ;
  bool reset = true;

  AddTrucksHeader({this.resetFunction , required this.reset});

  @override
  _AddTrucksHeaderState createState() => _AddTrucksHeaderState();
}

class _AddTrucksHeaderState extends State<AddTrucksHeader> {
  @override
  Widget build(BuildContext context) {

    ProviderData providerData = Provider.of<ProviderData>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(

          children: [
            Container(
              margin: EdgeInsets.only(right: space_2),
                child: BackButtonWidget()),
            Text(
                'Add Truck',
                style : TextStyle(
                  fontSize: size_10,
                  fontWeight: mediumBoldWeight,
                )),
          ],
        ),
        widget.reset ? TextButton(
            onPressed: providerData.resetActive ?  widget.resetFunction : null,
            child: Text(
                'Reset',
                style : TextStyle(
                  color: providerData.resetActive ? truckGreen : unactiveReset ,
                  fontSize: size_10,
                  fontWeight: regularWeight,
                )
            ))
            : SizedBox()
      ],
    );
  }
}
