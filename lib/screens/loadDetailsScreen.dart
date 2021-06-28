import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/additionalDescription_LoadDetails.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/buttons/bidButton.dart';
import 'package:liveasy/widgets/buttons/bookNowButton.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/loadPosterDetails_LoadDetails.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/widgets/locationDetails_LoadDetails.dart';
import 'package:liveasy/widgets/requirementsLoad_DetailsWidget.dart';
import 'package:liveasy/widgets/buttons/shareButton.dart';

// ignore: must_be_immutable
class LoadDetailsScreen extends StatelessWidget {
  LoadDetailsScreenModel loadDetails;

  LoadDetailsScreen({required this.loadDetails});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: space_4),
        child: Column(
          children: [
            SizedBox(
              height: space_4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BackButtonWidget(),
                SizedBox(
                  width: space_3,
                ),
                HeadingTextWidget("Load Details"),
                // HelpButtonWidget(),
              ],
            ),
            SizedBox(
              height: space_3,
            ),
            Stack(
              children: [
                LoadPosterDetailsLoadDetails(
                  loadPosterLocation: loadDetails.loadPosterLocation,
                  loadPosterName: loadDetails.loadPosterName,
                  loadPosterCompanyName: loadDetails.loadPosterCompanyName,
                  //TODO loadPosterCompanyApproved was string but I have changed it to bool for logical reasons shikhar please send boolean value here instead of string
                  loadPosterCompanyApproved:
                      loadDetails.loadPosterCompanyApproved == "true"
                          ? true
                          : false,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: space_6, top: (space_14 * 2) + 3, right: space_6),
                  child: Container(
                    height: 51,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(space_1 + 3)),
                    child: Card(
                        color: white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BidButton(loadDetails: loadDetails),
                            // CallButton(loadPosterPhoneNo: loadPosterPhoneNo)
                            CallButton(
                              directCall: true,
                              driverPhoneNum: loadDetails.phoneNo,
                            )
                          ],
                        )),
                  ),
                )
              ],
            ),
            Expanded(
              child: Card(
                elevation: 5,
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(space_3, space_2, space_3, space_3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LocationDetailsLoadDetails(
                        loadDetails: loadDetails,
                      ),
                      SizedBox(
                        height: space_3,
                      ),
                      Container(
                        color: lightGrayishBlue,
                        height: 1,
                      ),
                      SizedBox(
                        height: space_2,
                      ),
                      RequirementsLoadDetails(
                        loadDetails: loadDetails,
                      ),
                      SizedBox(
                        height: space_3,
                      ),
                      AdditionalDescriptionLoadDetails(loadDetails.comment),
                      SizedBox(
                        height: space_4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BookNowButton(
                            loadDetails: loadDetails,
                          ),
                          SizedBox(
                            width: space_2,
                          ),
                          ShareButton(
                            loadDetails: loadDetails,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
