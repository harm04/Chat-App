import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  const CustomButton({super.key, required this.height, required this.width, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Text(text,style: const TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.bold),)),
    );
  }
}