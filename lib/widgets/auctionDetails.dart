import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/spaces.dart';

class AuctionDetails extends StatelessWidget {
  final String? truckType;
  final String? noOfTyres;
  final String? weight;
  final String? productType;
  final String? loadPosterCompanyName;
  final String? rate;
  const AuctionDetails({
    super.key,
    required this.truckType,
    required this.noOfTyres,
    required this.weight,
    required this.productType,
    required this.loadPosterCompanyName,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.45,
      margin: EdgeInsets.only(bottom: space_2, top: space_2),
      child: Card(
        color: Colors.white,
        elevation: 3,
        child: Container(
          padding: EdgeInsets.only(
              top: space_2, bottom: space_2, left: space_4, right: space_2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Image(image: AssetImage('assets/icons/truck.png')),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      truckType!,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Image(image: AssetImage('assets/icons/tyreIcon.png')),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      noOfTyres!,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Image(image: AssetImage('assets/icons/weightIcon.png')),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      weight!,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Image(
                        image: AssetImage('assets/icons/productTypeIcon.png')),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      productType!,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Image(
                        image: AssetImage('assets/icons/companyNameIcon.png')),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      loadPosterCompanyName!,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Image(image: AssetImage('assets/icons/rateIcon.png')),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      rate!,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // [Text(data['loadId'])],
          ),
        ),
      ),
    );
  }
}
