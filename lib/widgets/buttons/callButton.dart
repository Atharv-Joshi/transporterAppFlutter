import 'package:flutter/material.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class CallButton extends StatelessWidget {
  String? loadPosterPhoneNo;

  CallButton({required this.loadPosterPhoneNo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchCaller("$loadPosterPhoneNo");
      },
      child: Container(
        height: 31,
        width: 80,
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(21, 41, 104, 1)),
            borderRadius: BorderRadius.circular(20)),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.call,
              ),
              Text(
                "Call",
                style: TextStyle(
                    fontSize: size_6 + 1, fontWeight: mediumBoldWeight),
              )
            ],
          ),
        ),
      ),
    );
  }
}

_launchCaller(String number) async {
  var url = "tel:$number";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
