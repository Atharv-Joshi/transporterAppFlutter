import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';


class TruckTypeButtonTemplate extends StatefulWidget {
  final String text ;
  final String value ;
  // final id;

  TruckTypeButtonTemplate({required this.value , required this.text});

  @override
  _TruckTypeButtonTemplateState createState() => _TruckTypeButtonTemplateState();
}

class _TruckTypeButtonTemplateState extends State<TruckTypeButtonTemplate> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      child: OutlinedButton(
        style: ButtonStyle(
            backgroundColor:
              providerData.truckTypeButtonId == widget.value
                  ? MaterialStateProperty.all(darkBlueColor) : MaterialStateProperty.all(whiteBackgroundColor),


            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                )
            )
        ),
        child: Text(
            '${widget.text}',
              style: TextStyle(
                fontSize: size_7,
                color:  providerData.truckTypeButtonId == widget.value ? white : black
              ),),
        onPressed: (){

          providerData.updateTruckTypeButtonId(widget.value);
          // setState(() {
          //   selected = true;
          //   truckTypeButtonController.updateButtonState(false);
          // });
        },
      ),
    );
  }
}
