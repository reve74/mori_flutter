import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController? textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final Icon frefix;
  final validator;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  bool? enable = true;

   TextFieldInput({
    Key? key,
    this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    required this.frefix,
    this.validator,
    required this.hintStyle,
    required this.textStyle,
     this.enable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextFormField(
      enabled: enable,
      validator: validator,
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: frefix,
        hintText: hintText,
        hintStyle: hintStyle,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      style: textStyle,
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
