import 'package:flutter/material.dart';
import 'package:project_collabity/pages/auth.pages.dart';
import 'package:project_collabity/services/theme.services.dart';

void main() => runApp(AppRoot());

// UI responsible
class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: DefaultTheme,
      home: AuthPage()
    );
  }
} 