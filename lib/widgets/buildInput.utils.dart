import 'package:flutter/material.dart';
import 'package:project_collabity/utils/ui.utils.dart';

///Building the Email input for using in the Login and SignUp
Widget buildInput({bool obscureText, icon, labelText, Function change}) {
  Color borderCo = HexColor('#88d5cb');

  return Container(
    padding: EdgeInsets.only(top: 35, left: 20, right: 20),
    child: Column(
      children: <Widget>[
        TextField(
          onChanged: change,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: borderCo)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: borderCo)),
              labelText: labelText,
              labelStyle: TextStyle(
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              )
          ),
        )
      ],
    )
  );
}