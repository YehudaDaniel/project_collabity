import 'package:flutter/material.dart';
import 'package:project_collabity/utils/ui.utils.dart';

///Social Authentication rounded Button
Widget buildAuth(String path, Size size){
  return Padding(
    padding: EdgeInsets.all(20),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: HexColor('#88d5cb')),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
        elevation: 8,
        child: GestureDetector(
          onTap: () {},
          child: Image.asset(path, width: size.width * 0.15, height: size.width * 0.15)
        )
      ),
    ),
  );
}