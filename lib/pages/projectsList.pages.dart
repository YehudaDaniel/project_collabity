import 'package:flutter/material.dart';
import 'package:project_collabity/pages/texteditor.pages.dart';
import 'package:project_collabity/utils/flutter_ui_utils.dart';
import 'package:project_collabity/services/http.services.dart';

class ProjectsList extends StatefulWidget {
  @override
  _ProjectsListState createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  List<ProjectData> projects = List();

  @override
  void initState() {
    super.initState();

    HttpServices.projectsList().then((projectsFromServer){
      setState(() {
        projects = projectsFromServer;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: _getNavBar(context, size),
        body:  SafeArea(child: _listingProjects(context))
        // Container(
        //   child: Center(
        //     child: Text('No Projects', style: TextStyle(fontSize: 40)),
        //   ),
        // ),
    );
  }

  ///Displaying the users current projects list
  Widget _listingProjects(context) {
    return ListView.builder(
        // controller: scrollController,
        padding: EdgeInsets.all(10),
        itemCount: projects.length,
        itemBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        projects[index].title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black
                        )
                      ),
                      SizedBox(height: 25),
                      Text(
                        projects[index].content,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey
                        )
                      ),
                    ],
                  ),
                ]
              ),
            ),
          );
        }
      );
  }

  ///Building special bottom navigation bar widget function
  Widget _getNavBar(context, size) {
    return Container(
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TextEditorPage()));
              },
              backgroundColor: HexColor('#88d5cb'),
              child: Icon(Icons.add, size: 50, color: Colors.grey[300]),
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
    );
  }
}

///A class for the custom painter of the navigation button
class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 30);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.36, 0);
    path.arcToPoint(Offset(size.width * 0.65, 45),
        radius: Radius.circular(10), clockwise: true);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 30);
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
