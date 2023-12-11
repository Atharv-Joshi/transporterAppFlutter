import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color.dart';

class ConfirmButton extends StatelessWidget {
  var onPressed;
  final String text;

  ConfirmButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: navy,
        fixedSize: Size(MediaQuery.of(context).size.width * 0.25,
            MediaQuery.of(context).size.height * 0.07),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
