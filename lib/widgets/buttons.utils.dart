import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project_collabity/utils/ui.utils.dart';

///Building a rounded button for future use in code
Widget roundedButton({String text, Function tapMethod}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical:30),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: HexColor('#88d5cb')),
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: 50.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        elevation: 6,
        child: GestureDetector(
          onTap: tapMethod,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
                fontSize: 20,
              )
            )
          )
        )
      )
    ),
  );
}

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