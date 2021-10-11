import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import 'package:liveasy/functions/trasnporterApis/runTransporterApiPost.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/buttons/getStartedButton.dart';
import 'package:provider/provider.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? transporterId;
  bool? _nextScreen = false;
  TransporterIdController transporterIdController =
  Get.put(TransporterIdController(), permanent: true);
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    bool? transporterApproved;
    bool? companyApproved;
    String? mobileNum;
    bool? accountVerificationInProgress;
    String? transporterLocation;
    String? name;
    String? companyName;

    transporterId = await runTransporterApiPost(
      mobileNum:  FirebaseAuth
        .instance.currentUser!.phoneNumber
        .toString()
        .substring(3, 13),);

    if (transporterId != null){
      setState(() {
        _nextScreen=true;
      });
    }
    else {
      setState(() {
        transporterId = tidstorage.read("transporterId");
        transporterApproved = tidstorage.read("transporterApproved");
        companyApproved = tidstorage.read("companyApproved");
        mobileNum = tidstorage.read("mobileNum");
        accountVerificationInProgress = tidstorage.read("accountVerificationInProgress");
        transporterLocation = tidstorage.read("transporterLocation");
        name = tidstorage.read("name");
        companyName = tidstorage.read("companyName");
      });

      if (transporterId == null) {
        print("Transporter ID is null");
      } else {
        print("It is in else");
        transporterIdController.updateTransporterId(transporterId!);
        transporterIdController.updateTransporterApproved(transporterApproved!);
        transporterIdController.updateCompanyApproved(companyApproved!);
        transporterIdController.updateMobileNum(mobileNum!);
        transporterIdController
            .updateAccountVerificationInProgress(accountVerificationInProgress!);
        transporterIdController.updateTransporterLocation(transporterLocation!);
        transporterIdController.updateName(name!);
        transporterIdController.updateCompanyName(companyName!);
        print("transporterID is $transporterId");
      }
      setState(() {
        _nextScreen=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ProviderData>(context);
    final currentItem = provider.languageItem;
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: EdgeInsets.only(left: space_4, right: space_4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
                child: Padding(
                  padding:
                  EdgeInsets.fromLTRB(space_5, space_8, space_5, space_0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: space_5, right: space_5),
                        child: Image(
                            image: AssetImage("assets/icons/welcomeIcon.png")),
                      ),
                      Text(AppLocalizations.of(context)!.welcome,
                        style: TextStyle(
                            fontSize: size_11, fontWeight: boldWeight),
                      ),
                      SizedBox(
                        height: space_6,
                      ),
                      Text(AppLocalizations.of(context)!.selectLanguage,
                        style: TextStyle(
                            fontSize: size_10, fontWeight: normalWeight),
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                selectLanguageItem(context, LanguageItem.English);
                                provider.setLocale(Locale('en'));
                              },
                              child: Container(
                                height: space_8,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1,
                                        color:currentItem == LanguageItem.English ? navy : darkGreyColor
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(radius_1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "English",
                                      style: TextStyle(
                                          color: currentItem == LanguageItem.English ? navy : darkGreyColor,
                                          fontSize: size_9,
                                          fontWeight: normalWeight),
                                    ),
                                    Container(
                                      child: currentItem == LanguageItem.English? Image(
                                        image: AssetImage("assets/icons/tick.png"),
                                        width: space_3,
                                        height: space_3,
                                      ): Container(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: space_2,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                  selectLanguageItem(context, LanguageItem.Hindi);
                                  provider.setLocale(Locale('hi'));
                              },
                              child: Container(
                                height: space_8,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: currentItem == LanguageItem.Hindi ? navy : darkGreyColor
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(radius_1)),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Hindi",
                                      style: TextStyle(
                                          color: currentItem == LanguageItem.Hindi ? navy : darkGreyColor,
                                          fontSize: size_9,
                                          fontWeight: normalWeight),
                                    ),
                                Container(
                                  child: currentItem == LanguageItem.Hindi ? Image(
                                    image: AssetImage("assets/icons/tick.png"),
                                    width: space_3,
                                    height: space_3,
                                  ): Container(),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: space_5,
                      ),
                      GetStartedButton(nextScreen: _nextScreen)
                    ],
                  ),
                ),
              ),
              color: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius_5),
              ),
            )
          ],
        ),
      ),
    );
  }

  void selectLanguageItem(BuildContext context, LanguageItem item) {
    final provider = Provider.of<ProviderData>(context, listen: false);
    provider.setLanguageItem(item);
  }
}
