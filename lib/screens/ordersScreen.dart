import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/responsive.dart';
import 'package:liveasy/widgets/OrderScreenNavigationBarButton.dart';
import 'package:liveasy/screens/TransporterOrders/biddingScreenTransporterSide.dart';
import 'package:provider/provider.dart';
import 'TransporterOrders/deliveredScreenOrders.dart';
import 'TransporterOrders/onGoingScreenOrders.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late PageController pageController;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    ProviderData providerData = Provider.of<ProviderData>(context);
    PageController pageController =
        PageController(initialPage: providerData.upperNavigatorIndex);

    return Scaffold(
      backgroundColor: headerLightBlueColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(
                (Responsive.isDesktop(context) || Responsive.isTablet(context))
                    ? space_0
                    : space_4,
                space_4,
                space_4,
                space_2),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: space_2),
                  color: Color.fromRGBO(245, 246, 250, 1),
                  child: Row(
                    children: [
                      Text(
                        'Orders'.tr,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: black,
                            fontWeight: FontWeight.w600,
                            fontSize: (Responsive.isMobile(context))
                                ? size_10
                                : size_15),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      //Order Screen Navigation Bar is used to navigate through the orders screen
                      OrderScreenNavigationBarButton(
                          text: 'bids'.tr,
                          // AppLocalizations.of(context)!.bids,
                          value: 0,
                          pageController: pageController),
                      OrderScreenNavigationBarButton(
                          text: 'on_going'.tr,
                          // AppLocalizations.of(context)!.on_going,
                          value: 1,
                          pageController: pageController),
                      OrderScreenNavigationBarButton(
                          text: 'completed'.tr,
                          // AppLocalizations.of(context)!.completed,
                          value: 2,
                          pageController: pageController)
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: PageView(
                    controller: pageController,
                    children: [
                      BiddingScreenTransporterSide(),
                      OngoingScreenOrders(),
                      DeliveredScreenOrders(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
