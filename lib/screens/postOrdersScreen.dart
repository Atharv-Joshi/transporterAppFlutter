import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/OrderScreenNavigationBarButton.dart';
import 'package:liveasy/widgets/deliveredCard.dart';
import 'package:liveasy/widgets/onGoingCard.dart';
import 'package:provider/provider.dart';

class PostOrdersScreen extends StatefulWidget {
  const PostOrdersScreen({Key? key}) : super(key: key);

  @override
  _PostOrdersScreenState createState() => _PostOrdersScreenState();
}

class _PostOrdersScreenState extends State<PostOrdersScreen> {

  List screens = [
    Text('loads'),
    OngoingCard(),
    DeliveredCard(),
  ];

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

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
                  OrderScreenNavigationBarButton(text: 'My Loads', value: 0),
                  OrderScreenNavigationBarButton(text: 'On-going', value: 1),
                  OrderScreenNavigationBarButton(text: 'Delivered', value: 2)
                ],
              ),
              Divider(

                color: textLightColor,
                thickness: 1,
              ),
              Container(
                child: screens[providerData.upperNavigatorIndex],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
