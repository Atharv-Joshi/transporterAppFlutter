// This file basically returns the URLs as you can see after fetching it from the env file ~ 👌😒

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_config/flutter_config.dart';

class UrlGetter {

  static Future<String> get(String key) async {
    print("TRYING TO GET '$key' URL ------------------------");
    await dotenv.load(fileName: ".env");  // Calling the env get method through dot_env------

    switch (key) {
      case "loadApiUrl" :
        String loadApiUrl = kIsWeb ? dotenv.get('loadApiUrl').toString() : FlutterConfig.get("loadApiUrl").toString();
        debugPrint("$loadApiUrl--------------LOAD API URL-----------------------");
        return loadApiUrl;
        break;
      case "transporterApiUrl" :
        String transporterApiUrl = kIsWeb ? dotenv.get('transporterApiUrl').toString() : FlutterConfig.get("transporterApiUrl").toString();
        debugPrint("$transporterApiUrl--------------TRANSPORTER API URL-----------------------");
        return transporterApiUrl;
        break;
      case "truckApiUrl" :
        String truckApiUrl = kIsWeb ? dotenv.get('truckApiUrl').toString() : FlutterConfig.get("truckApiUrl").toString();
        debugPrint("$truckApiUrl --------------TRUCK API URL-----------------------");
        return truckApiUrl;
      default:
        print("ERROR IN GENERATING URL----------------");
        return "NULL";
    }
  }

}