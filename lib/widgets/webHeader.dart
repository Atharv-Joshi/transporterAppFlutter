import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color.dart';
import '../constants/fontSize.dart';

class WebHeader extends StatelessWidget {
  const WebHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
                width: MediaQuery.of(context).size.width * 0.04,
                height: MediaQuery.of(context).size.height * 0.04,
                image: const AssetImage("assets/images/logoWebLogin.png")),
            Padding(
              padding: EdgeInsets.only(left: 0.5),
              child: Text("Liveasy",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      color: bidBackground,
                      fontSize: size_14)),
            ),
          ],
        ),
      ),
    );
  }
}
