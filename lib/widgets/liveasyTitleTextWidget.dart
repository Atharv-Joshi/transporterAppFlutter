import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';

class LiveasyTitleTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Center(
        child: Text(
          "Liveasy",
          style: TextStyle(
              fontSize: 24,
              color: Color(0xFF000066),
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
