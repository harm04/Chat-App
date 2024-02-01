import 'package:flutter/material.dart';


class CustomTextfield extends StatelessWidget {
  final String hinttext;
   final bool isobscureText;
   final icon;
   final label;
   final onsaved;
   final validator;
  final TextEditingController controller;
  const CustomTextfield({super.key,this.label, required this.hinttext,required this.isobscureText, required this.controller,required this.icon, this.onsaved, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onsaved,
      validator: validator,
      obscureText:isobscureText ,
      controller:controller,
      
      decoration: InputDecoration(
        label: label,
        hintText: hinttext,hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon),fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15)
        )
      ),
    );
  }
}