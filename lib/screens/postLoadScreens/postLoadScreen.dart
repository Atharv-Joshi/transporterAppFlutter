import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/myLoadPages/deliveredScreen.dart';
import 'package:liveasy/screens/myLoadPages/myLoadsScreen.dart';
import 'package:liveasy/screens/myLoadPages/onGoingScreen.dart';
import 'package:liveasy/widgets/Header.dart';
import 'package:liveasy/widgets/OrderScreenNavigationBarButton.dart';
import 'package:liveasy/widgets/buttons/viewBidsButton.dart';
import 'package:provider/provider.dart';

class PostOrdersScreen extends StatefulWidget {
  const PostOrdersScreen({Key? key}) : super(key: key);

  @override
  _PostOrdersScreenState createState() => _PostOrdersScreenState();
}

class _PostOrdersScreenState extends State<PostOrdersScreen> {

  //Page Controller
  PageController pageController = PageController(initialPage:0);

  int currentPage = 0;

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
                  OrderScreenNavigationBarButton(text: 'My Loads', value: 0 , pageController : pageController),
                  OrderScreenNavigationBarButton(text: 'On-going', value: 1 , pageController : pageController),
                  OrderScreenNavigationBarButton(text: 'Delivered', value: 2 , pageController : pageController)
                ],
              ),
              Divider(
                color: textLightColor,
                thickness: 1,
              ),
              Container(
                height: 600,
                child: PageView(
                  controller: pageController,
                  onPageChanged: (value){
                    setState(() {
                      providerData.updateUpperNavigatorIndex(value);
                    });
                  },
                  children: [
                    MyLoadsScreen(),
                    OngoingScreen(),
                    DeliveredScreen(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
