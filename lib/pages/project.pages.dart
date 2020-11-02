import 'package:flutter/material.dart';
import 'package:project_collabity/services/http.services.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (value){
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Home')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Home')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Home')
          ),
        ],
      ),
      body: PageView(
        children: <Widget>[
          _project(),
          _project(),
          _project(),
        ],
      )
    );
  }

  Widget _project(){
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05, vertical: MediaQuery.of(context).size.height*0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'NAME',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500]
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: (){},
                      elevation: 0.2,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    )
                  ]
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05, vertical: 20),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:20, vertical:25),
                child: Text(
                  'asfasfasfsafasfasfasfasfssssssssssssssssssssssssssssssss saaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.black
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: (){},
                    elevation: 0.2,
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.add,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                ]
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: _featuresList()
            ),
          )
        ],
      ),
    );
  }

  Widget _featuresList(){
    return FutureBuilder(
      future: HttpServices.getFeatures(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('none');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                // scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Text('NAME'),
                    subtitle: Text(snapshot.data[index].content),
                    // isThreeLine: true,
                    // dense: true,
                    trailing: Icon(Icons.more_vert)
                  );
                },
              );
            }
            return CircularProgressIndicator();
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}