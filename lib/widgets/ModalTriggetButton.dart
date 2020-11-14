//A widget which provides the button for the texteditor page for triggering the modalbox sheet, for adding collaborators.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:project_collabity/services/http.services.dart';
import 'package:project_collabity/utils/User.dart';


class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action){
    if(null != _timer){
      _timer.cancel();
    }
    _timer = Timer(Duration(microseconds: milliseconds), action);
  }
}

class ModalTriggerButton extends StatefulWidget {
  final Function(List<String>) changeCallback;
  final List<String> collabsList;

  ModalTriggerButton({ this.changeCallback, this.collabsList });

  @override
  _ModalTriggerButtonState createState() => _ModalTriggerButtonState();
}

class _ModalTriggerButtonState extends State<ModalTriggerButton> {
  final List<String> collabsList = [];

  final _focusNode = FocusNode();

  //A variable to hold the list of users
  final _debouncer = Debouncer(milliseconds: 500);
  List<User> users = List();
  List<User> filteredUsers = List();

  bool initHeight = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print(initHeight);
      if(_focusNode.hasFocus){
        print(1);
        setState(() {
          initHeight = true;
        });
      }else{
        setState(() {
          initHeight = false;
        });
      }
    });
    HttpServices.getCollaborators().then((usersFromServer){
      setState(() {
        users = usersFromServer;
        filteredUsers = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton( // "Lets us play with the canvas" button.
      onPressed: (){
        _modalBottomSheet(context); // pops up the modal sheet.
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(collabsList.length > 0? Icons.check_circle : Icons.add_circle_outline),
          Text(
            'Add collaborators',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            )
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }

  //pops up the modal sheet.
  //TODO: fix ~ when touching outside the bottom sheet, make it dismiss.
  //TODO: when textfield is focus, let bottomsheet rise up to avoid keyboard.
  _modalBottomSheet(context){
    showModalBottomSheet<void>(context: context,
    isScrollControlled: true,
    isDismissible: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5,
        builder: (context, scrollController){
          return Container(
            padding: EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:Radius.circular(40),
                topRight: Radius.circular(40)
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Search Collaborators...',
                    ),
                    onChanged: (string) {
                      _debouncer.run(() {
                        setState(() {
                          filteredUsers = users.where((u) => (u.name.toLowerCase().contains(string.toLowerCase()) || 
                          u.email.toLowerCase().contains(string.toLowerCase()))).toList();
                        });
                      });
                    }
                  ),
                ),
                Expanded(
                  //TODO: when selecting a collaborator, pop him to the top of the list.
                  //TODO: display the garbage button only on selected items
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.all(10),
                    itemCount:  filteredUsers.length,
                    itemBuilder: (BuildContext context, int index){
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        child: FlatButton(
                          onPressed: (){
                            setState(() {
                              if(!collabsList.contains(filteredUsers[index].name)){
                                collabsList.add(filteredUsers[index].name);
                                widget.changeCallback(collabsList);
                              }
                            });
                            print(collabsList);
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:<Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.delete,
                                      size: 25,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        filteredUsers[index].name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black
                                        )
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        filteredUsers[index].email,
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
                          ),
                        ),
                        actions: <Widget>[
                          IconSlideAction(
                            icon: Icons.cancel,
                            color: Colors.red[200],
                            onTap: (){
                              if(collabsList.contains(filteredUsers[index].name)){
                                setState(() {
                                  collabsList.remove(filteredUsers[index].name);
                                });
                                print(collabsList);
                              }
                            },
                          ),
                        ],
                        key: ObjectKey(filteredUsers),
                      );
                    },
                  )
                )
              ],
            )
          );
        },
      );
    });
  }

  //http://jsonplaceholder.typicode.com/users
}