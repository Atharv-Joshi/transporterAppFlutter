import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/spaces.dart';
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
class LoadDetailsScreen extends StatefulWidget {
  var loadDetailsScreenModel;

  LoadDetailsScreen({this.loadDetailsScreenModel});

  @override
  _LoadDetailsScreenState createState() => _LoadDetailsScreenState();
}

class _LoadDetailsScreenState extends State<LoadDetailsScreen> {
  String? loadId;
  String? loadingPoint;
  String? loadingPointCity;
  String? loadingPointState;
  String? id;
  String? unloadingPoint;
  String? unloadingPointCity;
  String? unloadingPointState;
  String? productType;
  String? truckType;
  String? noOfTrucks;
  String? weight;
  String? comment;
  String? status;
  String? date;
  String? loadPosterId;
  String? loadPosterPhoneNo;
  String? loadPosterLocation;
  String? loadPosterName;
  String? loadPosterCompanyName;
  String? loadPosterKyc;
  String? loadPosterCompanyApproved;
  String? loadPosterApproved;
  String? loadPosterAccountVerificationInProgress;

  @override
  Widget build(BuildContext context) {
    loadId = widget.loadDetailsScreenModel.loadId;
    loadingPoint = widget.loadDetailsScreenModel.loadingPoint;
    loadingPointCity = widget.loadDetailsScreenModel.loadingPointCity;
    loadingPointState = widget.loadDetailsScreenModel.loadingPointState;
    id = widget.loadDetailsScreenModel.id;
    unloadingPoint = widget.loadDetailsScreenModel.unloadingPoint;
    unloadingPointCity = widget.loadDetailsScreenModel.unloadingPointCity;
    unloadingPointState = widget.loadDetailsScreenModel.unloadingPointState;
    productType = widget.loadDetailsScreenModel.productType;
    truckType = widget.loadDetailsScreenModel.truckType;
    noOfTrucks = widget.loadDetailsScreenModel.noOfTrucks;
    weight = widget.loadDetailsScreenModel.weight;
    comment = widget.loadDetailsScreenModel.comment;
    status = widget.loadDetailsScreenModel.status;
    date = widget.loadDetailsScreenModel.date;
    loadPosterId = widget.loadDetailsScreenModel.loadPosterId;
    loadPosterPhoneNo = widget.loadDetailsScreenModel.loadPosterPhoneNo;
    loadPosterLocation = widget.loadDetailsScreenModel.loadPosterLocation;
    loadPosterName = widget.loadDetailsScreenModel.loadPosterName;
    loadPosterCompanyName = widget.loadDetailsScreenModel.loadPosterCompanyName;
    loadPosterKyc = widget.loadDetailsScreenModel.loadPosterKyc;
    loadPosterCompanyApproved =
        widget.loadDetailsScreenModel.loadPosterCompanyApproved;
    loadPosterApproved = widget.loadDetailsScreenModel.loadPosterApproved;
    loadPosterAccountVerificationInProgress =
        widget.loadDetailsScreenModel.loadPosterAccountVerificationInProgress;
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: space_4),
        child: Column(
          children: [
            SizedBox(
              height: space_8,
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
                  loadPosterLocation: loadPosterLocation,
                  loadPosterName: loadPosterName,
                  loadPosterCompanyName: loadPosterCompanyName,
                  loadPosterCompanyApproved: loadPosterCompanyApproved,
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
                            BidButton(loadId),
                            CallButton(loadPosterPhoneNo: loadPosterPhoneNo)
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
                        loadingPoint: loadingPoint,
                        loadingPointCity: loadingPointCity,
                        loadingPointState: loadingPointState,
                        unloadingPoint: unloadingPoint,
                        unloadingPointCity: unloadingPointCity,
                        unloadingPointState: unloadingPointState,
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
                          truckType, "NA", weight, productType),
                      SizedBox(
                        height: space_3,
                      ),
                      AdditionalDescriptionLoadDetails(comment),
                      SizedBox(
                        height: space_4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BookNowButton(
                            loadId: loadId,
                          ),
                          SizedBox(
                            width: space_2,
                          ),
                          ShareButton(loadingPointCity: loadingPointCity)
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
