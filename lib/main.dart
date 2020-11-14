import 'package:flutter/material.dart';
import 'package:project_collabity/pages/auth.pages.dart';
import 'package:project_collabity/pages/projectsList.pages.dart';
// import 'package:project_collabity/pages/auth.pages.dart';
// import 'package:project_collabity/pages/project.pages.dart';
// import 'package:project_collabity/pages/texteditor.pages.dart';
import 'package:project_collabity/services/theme.services.dart';

void main() => runApp(AppRoot());

// UI responsible
class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: defaultTheme,
      // home: AuthPage()
      // home: ProjectPage()
      home: ProjectsList()
    );
  }
} 