import 'package:flutter/material.dart';

enum SmartTextType {
  H1, 
  T, 
  QUOTE, 
  BULLET 
}

extension SmartTextStyle on SmartTextType {
  TextStyle get textStyle {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextStyle(
          fontSize: 16.0,
          fontStyle: FontStyle.italic,
          color: Colors.black
        );
      case SmartTextType.H1:
        return TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold);
        break;
      default:
        return TextStyle(fontSize: 16.0);
    }
  }
  
  EdgeInsets get padding {
    switch (this) {
      case SmartTextType.H1:
        return EdgeInsets.fromLTRB(16, 20, 16, 5);
        break;
      case SmartTextType.BULLET:
        return EdgeInsets.fromLTRB(20, 5, 16, 5);
      default:
        return EdgeInsets.fromLTRB(16, 5, 16, 5);
    }
  }

  TextAlign get align {
    switch (this) {
      case SmartTextType.QUOTE:
        return TextAlign.center;
        break;
      default:
        return TextAlign.start;
    }
  }

  String get prefix {
    switch (this) {
      case SmartTextType.BULLET:
        return '\u2022 ';
        break;
      default:
    }
  }
}

class SmartTextField extends StatelessWidget {

  final SmartTextType type;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function change;
  const SmartTextField({Key key, this.type, this.controller, this.focusNode, this.change}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: change,
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      cursorColor: Colors.black,
      textAlign: type.align,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixText: type.prefix,
        prefixStyle: type.textStyle,
        isDense: true,
        contentPadding: type.padding
      ),
      style: type.textStyle
    );
  }
}