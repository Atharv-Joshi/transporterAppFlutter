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
          // Get.to(() => CityNameInputGMaps(hintText));
          const kGoogleApiKey = "AIzaSyBLJ8zwqBOM7yK_FYqGuKsiv8_huRvQwe8";
          var uuid = Uuid();
          uuid.v4();
          await PlacesAutocomplete.show(
              context: context,
              apiKey: kGoogleApiKey,
              mode: Mode.overlay,
              language: "en",
              sessionToken: "$uuid",
              types: [],
              strictbounds: false,
              components: [Component(Component.country, "in")]).then((value) {
            if (value != null) {
              print(value.description);
              List<String> result = value.description!.split(",");
              int resultLenght = 0;
              for (var r in result) {
                resultLenght++;
                r = r.trimLeft();
                r = r.trimRight();
                print(r);
              }
              if (hintText == "Loading Point") {
                Provider.of<ProviderData>(context, listen: false)
                    .updateLoadingPointFindLoad(
                        city: result[resultLenght - 3].toString(),
                        state: result[resultLenght - 2].toString());
              } else if (hintText == "Unloading Point") {
                Provider.of<ProviderData>(context, listen: false)
                    .updateUnloadingPointFindLoad(
                        city: result[resultLenght - 3].toString(),
                        state: result[resultLenght - 2].toString());
              } else if (hintText == "Loading point") {
                Provider.of<ProviderData>(context, listen: false)
                    .updateLoadingPointPostLoad(
                        city: result[resultLenght - 3].toString(),
                        state: result[resultLenght - 2].toString());
              } else if (hintText == "Unloading point") {
                Provider.of<ProviderData>(context, listen: false)
                    .updateUnloadingPointPostLoad(
                        city: result[resultLenght - 3].toString(),
                        state: result[resultLenght - 2].toString());
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
