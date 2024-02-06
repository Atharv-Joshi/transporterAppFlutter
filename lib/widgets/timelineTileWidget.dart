import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:liveasy/constants/color.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_tile/timeline_tile.dart';
//this displays a timelinetile like Ui for displaying the fastag details
class TimeLineWidget extends StatefulWidget {
  List<dynamic>? location;
  String? vehicle;

  TimeLineWidget({this.location, this.vehicle});

  @override
  _TimeLineWidgetState createState() => _TimeLineWidgetState();
}

class _TimeLineWidgetState extends State<TimeLineWidget> {
  @override
  Widget build(BuildContext context) {
    //Check whether the location is empty or not. If yes, then show shimmer; otherwise, plot the data.
    return (widget.location == null || widget.location!.isEmpty)
        ? Container(
            child: ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 35),
                          child: Shimmer.fromColors(
                              baseColor: lightGrey,
                              highlightColor: greyishWhiteColor,
                              child: Container(
                                  height: 70, color: lightGrey, width: 150)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 4,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 70),
                          child: Shimmer.fromColors(
                              baseColor: lightGrey,
                              highlightColor: greyishWhiteColor,
                              child: Container(
                                height: 100,
                                color: lightGrey,
                              )),
                        ),
                      )
                    ],
                  );
                }),
          )
        : ListView.builder(
            itemCount: widget.location!.length,
            itemBuilder: (context, index) {
              final locations = widget.location![index];
              final time = DateTime.parse(locations['readerReadTime']);
              final indianTime = DateFormat('dd MMM yyyy, hh:mm a', 'en_US')
                  .format(time.toLocal());

              Widget buildCustomIndicator(int number) {
                return Transform.scale(
                  scale: 2.0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: darkBlueTextColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      number.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              }

              return Container(
                color: headerLightBlueColor,
                child: TimelineTile(
                  alignment: TimelineAlign.start,
                  isFirst: index == 0,
                  isLast: index == widget.location!.length - 1,
                  indicatorStyle: IndicatorStyle(
                    width: 50,
                    color: darkBlueTextColor,
                    padding: const EdgeInsets.all(6),
                    indicator: buildCustomIndicator(index + 1),
                  ),
                  beforeLineStyle: const LineStyle(
                    color: timelinesColor,
                    thickness: 2,
                  ),
                  endChild: Container(
                    padding: const EdgeInsets.only(
                      top: 25,
                      left: 30,
                      right: 30,
                      bottom: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locations['tollPlazaName'],
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        //Complete address of the tollPlaza
                        Text(
                          locations['address'],
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                          ),
                        ),

                        Text(
                          indianTime.toString(),
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
