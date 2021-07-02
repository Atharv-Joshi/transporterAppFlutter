import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';

class AddPostLoadHeader extends StatefulWidget {
  dynamic resetFunction;
  bool reset = true;

  AddPostLoadHeader({this.resetFunction, required this.reset});

  @override
  _AddPostLoadHeaderState createState() => _AddPostLoadHeaderState();
}

class _AddPostLoadHeaderState extends State<AddPostLoadHeader> {
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
            Text('Post Load',
                style: TextStyle(
                  fontSize: size_10,
                  fontWeight: mediumBoldWeight,
                )),
          ],
        ),
        widget.reset
            ? TextButton(
                onPressed:
                    providerData.resetActive ? widget.resetFunction : null,
                child: Text('Reset',
                    style: TextStyle(
                      color:
                          providerData.resetActive ? truckGreen : unactiveReset,
                      fontSize: size_10,
                      fontWeight: regularWeight,
                    )))
            : SizedBox()
      ],
    );
  }
}
