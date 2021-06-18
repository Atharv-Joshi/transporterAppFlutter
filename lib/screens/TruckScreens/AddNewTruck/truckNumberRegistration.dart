import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:liveasy/functions/driverApiCalls.dart';

//TODO: loading widget while post executes
class AddNewTruck extends StatefulWidget {
  const AddNewTruck({Key? key}) : super(key: key);

  @override
  _AddNewTruckState createState() => _AddNewTruckState();
}

class _AddNewTruckState extends State<AddNewTruck> {
  final  _formKey = GlobalKey<FormState>();

  TextEditingController _controller = TextEditingController();
  TruckApiCalls truckApiCalls = TruckApiCalls();
  DriverApiCalls driverApiCalls = DriverApiCalls();

  String? truckId ;

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
                              if (_controller.text != value.toUpperCase())
                                _controller.value = _controller.value.copyWith(text: value.toUpperCase());
                              value.isEmpty ? providerData.updateResetActive(false) : providerData.updateResetActive(true);
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]")),
                            ],
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
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: unselectedGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: MediumSizedButton(
                            text: 'Next',
                            optional: false,
                            onPressedFunction: providerData.resetActive ?
                                () async {

                              providerData.updateTruckNumberValue(
                                  _controller.text);

                              truckId = await truckApiCalls.postTruckData(
                                  truckNo: _controller.text) ;

                              if(truckId != null){
                                // driverApiCalls.getDriversByTransporterId();
                                providerData.updateResetActive(false);
                                Get.to(() => TruckDescriptionScreen(truckId!));

                              }
                              else{
                                Get.snackbar('Enter Correct truck Number', '');
                              }
                            }
                                : (){
                              // Get.snackbar('Enter Truck Number', '');
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
}