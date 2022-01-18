
import 'package:flutter/material.dart';
import 'package:liveasy/widgets/buttons/expiryButton.dart';

class whatsappShare extends StatefulWidget {
  const whatsappShare({ Key? key }) : super(key: key);

  @override
  _whatsappShareState createState() => _whatsappShareState();
}

class _whatsappShareState extends State<whatsappShare> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Text('Whatsapp pe share kare'),
                Text('Expiry time set kare'),
             //   expiryButton()
              ],
            ),
          )
        ],
      ),
    );
  }
}