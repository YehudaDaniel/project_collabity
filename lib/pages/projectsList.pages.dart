import 'package:flutter/material.dart';
import 'package:project_collabity/pages/texteditor.pages.dart';
import 'package:project_collabity/utils/flutter_ui_utils.dart';

class ProjectsList extends StatefulWidget {
  @override
  _ProjectsListState createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: _getNavBar(context, size),
      body: Stack(

      )
    );
  }

  ///Building special bottom navigation bar widget function
  Widget _getNavBar(context, size) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: size.width,
            height: 60,
            // color: Colors.blue,
            child: Stack(
              children: <Widget>[
                CustomPaint(
                  size: Size(size.width, 60),
                  painter: BNBCustomPainter(),
                ),
                Center(
                  heightFactor: 0.3,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TextEditorPage())
                      );
                    },
                    backgroundColor: HexColor('#88d5cb'),
                    child: Icon( 
                      Icons.add,
                      size: 50,
                      color: Colors.grey[300]
                    ),
                    elevation: 1,
                  ),
                ),
                // Container(
                //   width: size.width,
                //   height: 60,
                //   child: Row(
                //     children: <Widget>[
                //       IconButton(icon: null, onPressed: null,)
                //     ],
                //   )
                // )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 30);
    path.quadraticBezierTo(size.width*0.20, 0, size.width*0.35, 0);
    path.quadraticBezierTo(size.width*0.40, 0, size.width*0.36, 0);
    path.arcToPoint(Offset(size.width*0.65, 45),
      radius: Radius.circular(10),
      clockwise: true
    );
    path.quadraticBezierTo(size.width*0.60, 0, size.width*0.65, 0);
    path.quadraticBezierTo(size.width*0.80, 0, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.blue, 15, false);
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  } 
}