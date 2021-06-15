import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/truckApiCalls.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/truckDescriptionScreen.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/uploadRC.dart';
import 'package:liveasy/widgets/addTruckSubtitleText.dart';
import 'package:liveasy/widgets/addTrucksHeader.dart';
import 'package:liveasy/widgets/buttons/mediumSizedButton.dart';
import 'package:provider/provider.dart';
import 'package:liveasy/providerClass/providerData.dart';

class AddNewTruck extends StatefulWidget {
  const AddNewTruck({Key? key}) : super(key: key);

  @override
  _AddNewTruckState createState() => _AddNewTruckState();
}

class _AddNewTruckState extends State<AddNewTruck> {
  final  _formKey = GlobalKey<FormState>();

  TextEditingController _controller = TextEditingController();
  TruckApiCalls truckApiCalls = TruckApiCalls();

  String truckId = '';

  @override
  Widget build(BuildContext context) {

    ProviderData providerData = Provider.of<ProviderData>(context);


    return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_4),
            color: backgroundColor,
            child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddTrucksHeader(
                      reset: true,
                      resetFunction: () {
                        _controller.text = '';
                        providerData.resetTruckNumber();
                        providerData.updateResetActive(false);
                      },),
                    AddTruckSubtitleText(text: 'Truck Number'),

                    //TODO: center the hintext and apply shadows to textformfield
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: space_4),
                        width: 289,
                        height: 38,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            onChanged: (value){
                              value.isEmpty ? providerData.updateResetActive(false) : providerData.updateResetActive(true);
                            },
                            // key: _formKey,
                            validator: (value){
                              if(value!.replaceAll(' ', '').length == 10){
                                return null;
                              }
                              else{
                                Get.snackbar('Incorrect Truck Number', 'Enter correct truck number');
                              }
                            },
                            textCapitalization: TextCapitalization.characters,
                            controller: _controller,
                            // textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: whiteBackgroundColor,
                              hintText: 'Eg: UP 22 GK 2222',
                              hintStyle: TextStyle(
                                fontWeight: boldWeight,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: unselectedGrey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: unselectedGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //this button should only be active if validator check passes
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: MediumSizedButton(
                            text: 'Next',
                            onPressedFunction:
                                () async {

                              providerData.updateTruckNumberValue(
                                  _controller.text);

                              truckId = await truckApiCalls.postTruckData(
                                  truckNo: _controller.text) ;

                              providerData.updateResetActive(false);

                              Get.to(() => TruckDescriptionScreen(truckId));
                            }
                        ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }

  void validatorFunction(value){
    if(value!.replaceAll(' ', '').length == 10){
      return null;
    }
    else{
      Get.snackbar('Incorrect Truck Number', 'Enter correct truck number');
    }
  }
}
