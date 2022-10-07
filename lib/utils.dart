import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mori/util/colors.dart';

showSnackBar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: Colors.grey,
      duration: Duration(milliseconds: 1500),
    ),
  );
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No image selected');
}

class Themes {
  static final dark = ThemeData(
    backgroundColor: darkGreyClr,
    colorScheme: ColorScheme.dark().copyWith(
      primary: darkGreyClr,
    ),
    brightness: Brightness.dark,
    fontFamily: 'NotoSans',
  );
}

TextStyle get authText {
  return GoogleFonts.nanumMyeongjo(
    textStyle: const TextStyle(fontSize: 15, color: Colors.white),
  );
}

TextStyle get ts {
  return const TextStyle(
    fontSize: 18.0,
    color: Colors.white,
  );
}

TextStyle get titleStyle {
  return const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );
}

TextStyle get hintStyle {
  return const TextStyle(color: Colors.white60);
}

TextStyle get textStyle {
  return const TextStyle(color: Colors.white);
}
