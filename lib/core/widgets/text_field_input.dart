// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TextFieldImport extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool ispass;
  final String hinText;
  final TextInputType textInputType;

  const TextFieldImport({
    Key? key,
    required this.textEditingController,
     this.ispass = false,
    required this.hinText,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
          borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController, 
      decoration: InputDecoration(
        hintText: hinText, 
        border: inputBorder,
        focusedBorder: inputBorder , 
        enabledBorder: inputBorder, 
        filled: true, 
        contentPadding: const EdgeInsets.all(8)
      ),

      keyboardType: textInputType,
      obscureText: ispass,
    );
  }
}
