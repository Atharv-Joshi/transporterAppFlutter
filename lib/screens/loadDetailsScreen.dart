import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/widgets/additionalDescription_LoadDetails.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/buttons/bidButton.dart';
import 'package:liveasy/widgets/buttons/bookNowButton.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/loadPosterDetails.dart';
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
    return Scaffold(
      backgroundColor: statusBarColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: space_2),
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
                  LoadPosterDetails(
                    loadPosterLocation: loadDetails.loadPosterLocation,
                    loadPosterName: loadDetails.loadPosterName,
                    loadPosterCompanyName: loadDetails.loadPosterCompanyName,
                    loadPosterCompanyApproved : loadDetails.loadPosterCompanyApproved,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: space_8,
                        top: MediaQuery.of(context).size.height * 0.192,
                        right: space_8),
                    child: Container(
                      height: space_10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius_2 - 2)),
                      child: Card(
                        color: white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BidButton(loadDetails: loadDetails),
                            CallButton(
                              directCall: true,
                              driverPhoneNum: loadDetails.phoneNo,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Card(
                elevation: 5,
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(space_2, space_3, space_2, space_3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: space_3),
                        child: LocationDetailsLoadDetails(
                          loadDetails: {
                            "loadDate" : loadDetails.loadDate,
                            "loadingPoint" : loadDetails.loadingPoint ,
                            "loadingPointCity" : loadDetails.loadingPointCity,
                            "loadingPointState" : loadDetails.loadingPointState ,
                            "unloadingPoint" : loadDetails.unloadingPoint ,
                            "unloadingPointCity" : loadDetails.unloadingPointCity,
                            "unloadingPointState" : loadDetails.unloadingPointState,
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: space_2),
                        child: Divider(
                          thickness: 1,
                          color: borderLightColor,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: space_3),
                        child: RequirementsLoadDetails(
                          loadDetails: {
                            "truckType" : loadDetails.truckType,
                            "noOfTrucks" : loadDetails.noOfTrucks ,
                            "weight" : loadDetails.weight,
                            "productType" : loadDetails.productType,
                            "rate" : loadDetails.rate,
                            "unitValue" : loadDetails.unitValue,
                          },
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: space_4),
                          child: AdditionalDescriptionLoadDetails(loadDetails.comment)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BookNowButton(
                            loadDetails: loadDetails,
                          ),
                          ShareButton(
                            loadDetails: loadDetails,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
