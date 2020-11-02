import 'package:flutter/material.dart';

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
            height: 70,
            // color: Colors.blue,
            child: Stack(
              children: <Widget>[
                CustomPaint(
                  size: Size(size.width, 70),
                  painter: BNBCustomPainter(),
                ),
                Center(
                  heightFactor: 0.1,
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.orange,
                    child: Icon( 
                      Icons.add,
                      size: 55,
                      color: Colors.black
                    ),
                    elevation: 1,
                  ),
                ),
                // Container(
                //   width: size.width,
                //   height: 70,
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