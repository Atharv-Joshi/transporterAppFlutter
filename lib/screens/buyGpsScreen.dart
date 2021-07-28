import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BuyGpsScreen extends StatefulWidget {
  const BuyGpsScreen({Key? key}) : super(key: key);

  @override
  _BuyGpsScreenState createState() => _BuyGpsScreenState();
}

class _BuyGpsScreenState extends State<BuyGpsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text("Buy GPS")),
      );

  }
}
