import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/functions/kycIdfyApi.dart';
import 'package:liveasy/functions/trasnporterApis/updateTransporterApi.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import '../../constants/color.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({Key? key}) : super(key: key);

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  bool isLoaded = false;
  late String url;
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  apiCalling() async {
    url = await postCallingIdfy();
    print("URL--------------------->$url");
    if (url.isNotEmpty) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    apiCalling();
  }

  @override
  void dispose() {
    super.dispose();
    WebViewController().clearCache();
    WebViewController().clearLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(onProgress: (int progress) {
          print("in onProgress------------------------------------->$progress");
        }, onPageStarted: (String url) {
          print("in onPageStarted------------------------------------->$url");
        }, onPageFinished: (String url) async {
          print("in onPageFinished------------------------------------->$url");
          if (url.contains(
              "https://accounts.digitallocker.gov.in/oauth_partner/verify_otp")) {
            String status = await updateTransporterApi(
                accountVerificationInProgress: true,
                transporterId: transporterIdController.transporterId.value);
            if (status == "Success") {
              Navigator.pop(context);
            }
          }
        }, onWebResourceError: (WebResourceError error) {
          print("in onError------------------------------------->$error");
        }, onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }),
      )
      // ..loadRequest(Uri.parse(
      //     'https://capture.kyc.idfy.com/document-fetcher/digilocker/session-start/?reference_id=18110113&ou_id=ed728f377d5d&key_id=2753c121-d1d3-4402-8f4f-b896c9a024d5&h=2a85c15017accdf858dbe87d1a3966055c991273'));
      ..loadRequest(isLoaded ? Uri.parse(url) : Uri.parse('https:google.com'));
    return Material(
      child: isLoaded
          ? Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: WebViewWidget(controller: controller),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
