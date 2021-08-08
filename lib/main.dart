import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:get/get.dart';
import 'package:liveasy/screens/errorScreen.dart';
import 'package:liveasy/screens/spashScreenToGetTransporterData.dart';
import 'package:liveasy/translations/l10n.dart';
import 'package:liveasy/widgets/splashScreen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: ChangeNotifierProvider<ProviderData>(
        create: (context) => ProviderData(),
        builder: (context,child) {
          return FutureBuilder(
              future: Firebase.initializeApp(),
              builder: (context, snapshot) {
                final provider = Provider.of<ProviderData>(context);
                if (snapshot.connectionState == ConnectionState.done) {
                  if (FirebaseAuth.instance.currentUser == null) {
                    return GetMaterialApp(
                      builder: EasyLoading.init(),
                      theme: ThemeData(fontFamily: "montserrat"),
                      locale: provider.locale,
                      supportedLocales: L10n.all,
                      localizationsDelegates: [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                      ],
                      home: SplashScreen(),
                    );
                  } else {
                    var mUser = FirebaseAuth.instance.currentUser;
                    var task = mUser!.getIdToken(true).then((value) {
                      log(value);
                    });
                    return GetMaterialApp(
                      builder: EasyLoading.init(),
                      theme: ThemeData(fontFamily: "montserrat"),
                      locale: provider.locale,
                      supportedLocales: L10n.all,
                      localizationsDelegates: [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                      ],
                      home: SplashScreenToGetTransporterData(
                        mobileNum: FirebaseAuth.instance.currentUser!
                            .phoneNumber
                            .toString()
                            .substring(3, 13),
                      ),
                    );
                  }
                } else
                  return ErrorScreen();
              });

        },
      ),
    );
  }
}
