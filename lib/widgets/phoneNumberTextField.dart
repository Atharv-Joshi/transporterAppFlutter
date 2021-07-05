import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/widgets/linePainter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class PhoneNumberTextField extends StatefulWidget {
  @override
  _PhoneNumberTextFieldState createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: backgroundGrey)),
          child: Row(children: [
            Padding(
              padding: EdgeInsets.only(left: space_1),
              child: Container(
                width: space_3,
                height: space_3,
                child: Image(
                  image: AssetImage("assets/images/indianFlag.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: space_1, top: space_2),
              child: Container(
                width: space_5,
                height: space_5,
                child: Text(
                  "+91",
                  style: TextStyle(fontWeight: regularWeight, fontSize: size_6),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 2),
                height: space_6,
                width: space_1,
                child: CustomPaint(
                  foregroundPainter: LinePainter(),
                )),
            SizedBox(
              width: 200,
              child: TextFormField(
                onChanged: (_controller) {
                  if (_controller.length == 10) {
                    providerData.updateValidationText("");
                    providerData.updateInputControllerLengthCheck(true);
                    providerData.updateButtonColor(activeButtonColor);
                  } else {
                    providerData
                        .updateValidationText("Enter Valid Phone Number");
                    providerData.updateInputControllerLengthCheck(false);
                    providerData.updateButtonColor(deactiveButtonColor);
                  }
                  providerData.updatePhoneController(_controller);
                },
                controller: _controller,
                maxLength: 10,
                validator: (value) =>
                    value!.length == 10 ? null : 'Enter a valid Phone Number',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  filled: true,
                  fillColor: white,
                  hintText: 'Enter Phone Number',
                  hintStyle: TextStyle(color: darkCharcoal, fontSize: size_7),
                  // focusedBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(size_2),
                  //   borderSide: BorderSide(
                  //       style: BorderStyle.solid,
                  //       width: 1,
                  //       color: backgroundGrey),
                  // ),
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(
                  //       style: BorderStyle.solid,
                  //       width: 2,
                  //       color: backgroundGrey),
                  // ),
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.only(top: space_1),
          child: Text(
            providerData.validationText,
            style: TextStyle(
                color: declineButtonRed,
                fontSize: size_6,
                fontWeight: regularWeight),
          ),
        )
      ],
    );
  }
}
