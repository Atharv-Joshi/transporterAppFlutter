import 'package:flutter/material.dart';
import 'package:liveasy/constants/borderWidth.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/cancelIconWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:uuid/uuid.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_config/flutter_config.dart';

// ignore: must_be_immutable
class AddressInputGMapsWidget extends StatelessWidget {
  final String hintText;
  final Widget icon;
  final TextEditingController controller;
  var onTap;

  AddressInputGMapsWidget(
      {required this.hintText,
      required this.icon,
      required this.controller,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    String kGoogleApiKey = FlutterConfig.get('mapKey').toString();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space_6),
        border: Border.all(color: darkBlueColor, width: borderWidth_8),
        color: widgetBackGroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: space_3),
      child: TextFormField(
        readOnly: true,
        onTap: () async {
          providerData.updateResetActive(true);
          FocusScope.of(context).requestFocus(FocusNode());
          var uuid = Uuid();
          uuid.v4(); // for session token
          await PlacesAutocomplete.show(
              context: context,
              apiKey: kGoogleApiKey,
              mode: Mode.fullscreen,
              language: "en",
              logo: Text(""),
              sessionToken: "$uuid",
              types: ['(cities)'],
              strictbounds: false,
              components: [Component(Component.country, "in")]).then((value) {
            if (value != null) {
              print(value.description);
              List<String> result = value.description!.split(",");
              int resultLength = 0;
              for (var r in result) {
                resultLength++;
                r = r.trimLeft();
                r = r.trimRight();
                print(r);
              }
              if (resultLength > 2) {
                if (hintText == "Loading Point") {
                  Provider.of<ProviderData>(context, listen: false)
                      .updateLoadingPointFindLoad(
                          city: result[resultLength - 3].toString(),
                          state: result[resultLength - 2].toString());
                } else if (hintText == "Unloading Point") {
                  Provider.of<ProviderData>(context, listen: false)
                      .updateUnloadingPointFindLoad(
                          city: result[resultLength - 3].toString(),
                          state: result[resultLength - 2].toString());
                } else if (hintText == "Loading point") {
                  Provider.of<ProviderData>(context, listen: false)
                      .updateLoadingPointPostLoad(
                          city: result[resultLength - 3].toString(),
                          state: result[resultLength - 2].toString());
                } else if (hintText == "Unloading point") {
                  Provider.of<ProviderData>(context, listen: false)
                      .updateUnloadingPointPostLoad(
                          city: result[resultLength - 3].toString(),
                          state: result[resultLength - 2].toString());
                }
              } else {
                // only case of Delhi, India
                // updating values with Delhi (Delhi)
                if (hintText == "Loading Point") {
                  Provider.of<ProviderData>(context, listen: false)
                      .updateLoadingPointFindLoad(
                          city: result[0].toString(),
                          state: result[0].toString());
                } else if (hintText == "Unloading Point") {
                  Provider.of<ProviderData>(context, listen: false)
                      .updateUnloadingPointFindLoad(
                          city: result[0].toString(),
                          state: result[0].toString());
                } else if (hintText == "Loading point") {
                  Provider.of<ProviderData>(context, listen: false)
                      .updateLoadingPointPostLoad(
                          city: result[0].toString(),
                          state: result[0].toString());
                } else if (hintText == "Unloading point") {
                  Provider.of<ProviderData>(context, listen: false)
                      .updateUnloadingPointPostLoad(
                          city: result[0].toString(),
                          state: result[0].toString());
                }
              }
            } else {}
          });
        },
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          icon: icon,
          suffixIcon: GestureDetector(onTap: onTap, child: CancelIconWidget()),
        ),
      ),
    );
  }
}
