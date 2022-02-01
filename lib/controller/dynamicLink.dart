import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/widgets/whatsappShare.dart';

// ignore: must_be_immutable
class DynamicLinkService extends StatefulWidget {
  int deviceId;
  String? truckId;
  String? truckNo;
  DynamicLinkService({
    required this.deviceId,
    required this.truckId,
    required this.truckNo,
  });

  @override
  DynamicLink createState() => DynamicLink();
}

class DynamicLink extends State<DynamicLinkService> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        heroTag: "button2",
        backgroundColor: bidBackground,
        foregroundColor: Colors.white,
        child: const Icon(Icons.share_outlined, size: 30),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) => WhatsappShare(
                    deviceId: widget.deviceId,
                    truckId: widget.truckId,
                    truckNo: widget.truckNo,
                  ));
          print(MediaQuery.of(context).size.width);
        },
      ),
    );
  }
}
