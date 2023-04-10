import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/functions/kycIdfyApi.dart';
import 'package:liveasy/functions/trasnporterApis/updateTransporterApi.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:liveasy/controller/transporterIdController.dart';
import '../../constants/spaces.dart';
import '../../controller/navigationIndexController.dart';
import '../navigationScreen.dart';

class KYCIDfyScreen extends StatefulWidget {
  const KYCIDfyScreen({Key? key}) : super(key: key);

  @override
  State<KYCIDfyScreen> createState() => _KYCIDfyScreenState();
}

class _KYCIDfyScreenState extends State<KYCIDfyScreen> {
  bool isLoaded = false;
  late String url;
  TransporterIdController transporterIdController = Get.find<TransporterIdController>();
  NavigationIndexController navigationIndexController = Get.find<NavigationIndexController>();

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
              "https://capture.kyc.idfy.com/document-fetcher/digilocker/callback/?code=")) {
            String status = await updateTransporterApi(
                accountVerificationInProgress: false,
                verificationType: 'Immediate',
                transporterApproved: true,
                transporterId: transporterIdController.transporterId.value);
            if (status == "Success") {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigationScreen()));
            }
          }
          // This is used to redirect the page after successful completion of kyc and also here we are updating the transporter status
        }, onWebResourceError: (WebResourceError error) {
          print("in onError------------------------------------->$error");
        }, onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }),
      )
      ..loadRequest(isLoaded ? Uri.parse(url) : Uri.parse('https:google.com'));
    //this is checking whether the redirect url is ready or not, if yes that will displayed else circular progress bar will be displayed.
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, 0),
        child:isLoaded?
        WebViewWidget(controller: controller)
            : Center(child: CircularProgressIndicator()),
      )
    );
  }
}
