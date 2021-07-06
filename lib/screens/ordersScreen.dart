import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/OrderScreenNavigationBarButton.dart';
import 'package:liveasy/widgets/getBids.dart';
import 'package:provider/provider.dart';
import 'TransporterOrders/DeliveredScreenOrders/deliveredScreenOrders.dart';
import 'TransporterOrders/OnGoingScreenOrders/onGoingScreenOrders.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int i = 0;

  //Page Controller
  PageController pageController = PageController(initialPage: 0);

  int currentPage = 0;

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
                backButton: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OrderScreenNavigationBarButton(
                    text: 'Bids',
                    value: 0,
                    pageController: pageController,
                  ),
                  OrderScreenNavigationBarButton(
                    text: 'On-going',
                    value: 1,
                    pageController: pageController,
                  ),
                  OrderScreenNavigationBarButton(
                    text: 'Completed',
                    value: 2,
                    pageController: pageController,
                  )
                ],
              ),
              Divider(
                color: textLightColor,
                thickness: 1,
              ),
              Stack(
                children: [
                  Container(
                    height: 600,
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (value) {
                        setState(() {
                          providerData.updateUpperNavigatorIndex(value);
                        });
                      },
                      children: [
                        GetBids(),
                        OngoingScreenOrders(),
                        DeliveredScreenOrders(),
                      ],
                    ),
                  ),

                  // Positioned(
                  //   top: 50,
                  //   child: Align(
                  //       alignment: Alignment.center,
                  //       child: PostButtonLoad()
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
