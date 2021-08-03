import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';

class OkButtonForSameTruck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: space_8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(space_10),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: activeButtonColor,
              ),
              child: Text(
                'Ok',
                style: TextStyle(color: white, fontSize: size_8),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
      ),
    );
  }
}
