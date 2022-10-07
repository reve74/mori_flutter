import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainTitle extends StatelessWidget {
  const MainTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Mori',
      style: GoogleFonts.lobster(
        fontSize: 70.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
