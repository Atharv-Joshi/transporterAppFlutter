import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/OrderScreenNavigationBarButton.dart';
import 'package:liveasy/widgets/getBids.dart';
import 'package:liveasy/widgets/getBookingConfirmCard.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:swipe_to/swipe_to.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List screens = [GetBids(), Text('ongoing'), Text('Delivered')];
  int i = 0;

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    i = providerData.upperNavigatorIndex;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
          child: Column(
            children: [
              Header(
                reset: false,
                text: 'Orders',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OrderScreenNavigationBarButton(text: 'Bids', value: 0),
                  OrderScreenNavigationBarButton(text: 'On-going', value: 1),
                  OrderScreenNavigationBarButton(text: 'Delivered', value: 2)
                ],
              ),
              Divider(
                color: textLightColor,
                thickness: 1,
              ),
              SwipeTo(
                iconOnRightSwipe: null,
                iconOnLeftSwipe: null,
                onLeftSwipe: () {
                  print('i : $i');
                  if (i < 2) {
                    i = i + 1;
                    print('i after swiping : $i ');
                    providerData.updateUpperNavigatorIndex(i);
                  }
                },
                onRightSwipe: () {
                  print('i : $i');
                  if (i > 0) {
                    i = i - 1;
                    print('i after swiping : $i ');
                    providerData.updateUpperNavigatorIndex(i);
                  }
                },
                child: Container(
                  child: screens[providerData.upperNavigatorIndex],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
