import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

class OkButtonForSameTruck extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: space_8,
        margin: EdgeInsets.fromLTRB(space_8, space_0, space_8, space_20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(space_10),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: activeButtonColor,
              ),
              child: Text(
                'Ok',
                style: TextStyle(
                  color: white,
                ),
              ),
              onPressed: () {
                  Navigator.pop(context);
              }),
        ),
      ),
    ]);
  }
}
