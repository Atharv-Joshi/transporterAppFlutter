import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../constants/color.dart';
import '../constants/fontSize.dart';
import '../constants/spaces.dart';
import '../models/fastagModel.dart';

class TimelineTileFastag extends StatelessWidget {
  final List<TollPlazaData> responses;
  final List<String> addresses;

  TimelineTileFastag({
    required this.responses,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            itemCount: responses.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final tollPlazaData = responses[index];
              final address = addresses[index];

              // Format the timestamp
              final formattedDate = DateFormat('dd MMM yyyy')
                  .format(DateTime.parse(tollPlazaData.readerReadTime));
              final formattedTime = DateFormat('HH:mm')
                  .format(DateTime.parse(tollPlazaData.readerReadTime));

              return Column(
                children: [
                  //to display timeline in the bottom sheet
                  TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.2,
                    isFirst: index == 0,
                    isLast: index == responses.length - 1,
                    beforeLineStyle: LineStyle(
                      color: black,
                      thickness: 2,
                    ),
                    indicatorStyle: IndicatorStyle(
                      drawGap: true,
                      width: space_8,
                      height: space_8,
                      indicator: Container(
                        decoration: BoxDecoration(
                          color: darkBlueColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: white,
                              fontWeight: boldWeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                    endChild: Container(
                      padding: EdgeInsets.fromLTRB(
                          space_0, space_8, space_0, space_0),
                      child: Column(
                        children: [
                          Text(
                            tollPlazaData.tollPlazaName,
                            style: TextStyle(
                              fontFamily: 'Montserrat ',
                              fontSize: size_8,
                              fontWeight: boldWeight,
                              letterSpacing: 1,
                              color: black,
                            ),
                          ),
                          Text(
                            address,
                            style: TextStyle(
                              fontFamily: 'Montserrat ',
                              fontSize: size_7,
                              letterSpacing: 1,
                              color: black,
                            ),
                          ),
                          Text(
                            '$formattedDate $formattedTime', // Formatted date and time
                            style: TextStyle(
                              fontFamily: 'Montserrat ',
                              fontSize: size_6,
                              letterSpacing: 1,
                              color: greyishAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
