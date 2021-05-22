import 'package:flutter/material.dart';

class AddressInputWidget extends StatelessWidget {
  final String hintText;
  final Widget icon;

  AddressInputWidget(this.hintText, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 8,
        child: TextFormField(
          onTap: () {},
          decoration: InputDecoration(
            hintText: hintText,
            icon: icon,
          ),
        ),
      ),
    );
  }
}
