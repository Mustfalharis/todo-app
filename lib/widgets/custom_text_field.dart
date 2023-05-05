
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  CustomFormTextField({required this.hintText, this.onChanged, required this.controller});
  String? hintText;
  Function(String)? onChanged;
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:(data)
      {
        if(data!.isEmpty)
          return 'field is required';
      },

      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      controller: controller ,

    );
  }
}
