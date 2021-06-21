import 'package:flutter/material.dart';

class OrdersScreenNavigationBar extends StatelessWidget {
  const OrdersScreenNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: () {}, child: Text('My Loads')),
          TextButton(onPressed: () {}, child: Text('On-going')),
          TextButton(onPressed: () {}, child: Text('Delivered'))
        ],
      ),
    );
  }
}
