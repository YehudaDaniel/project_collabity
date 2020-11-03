import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:project_collabity/pages/TextEditorWidget/statemanage.pages.dart';
import 'package:project_collabity/pages/TextEditorWidget/textField.pages.dart';
import 'package:project_collabity/pages/TextEditorWidget/toolbar.pages.dart';
import 'package:provider/provider.dart';

class TextEditorPage extends StatefulWidget {
  TextEditorPage({Key key}) : super(key: key);

  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
  
  TextEditingController _textEditingController = TextEditingController();
  bool _isCollapsed = true;
  bool showToolbar = false;

  @override
  void initState(){
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (isVisible) {
        setState(() {
          showToolbar = isVisible;
        });
      },
    );
  }

  @override
  void dispose(){
    KeyboardVisibilityNotification().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditorProvider>(
      create: (context) => EditorProvider(),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: Column(
              children:<Widget>[
                Container(
                  color: Colors.grey[200],
                  child: Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed:() {
                            if(_isCollapsed){

                            }else{
                              setState(() {
                                _isCollapsed = !_isCollapsed;
                              });
                            }
                          },
                          icon: Icon(
                            _isCollapsed? Icons.keyboard_arrow_left : Icons.keyboard_arrow_up,
                            size: 35,
                          ),
                        ),
                        IconButton(
                          onPressed:() {

                          },
                          icon: Icon(
                            Icons.done,
                            color: Colors.green,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  child: Expanded(
                    flex: 1,
                    child: _expandingCollapsingWidget(),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: _textEditorWidget(),
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _textEditorWidget(){
    return  Stack(
      children: <Widget>[
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          bottom: 56,
          child: Consumer<EditorProvider>(
            builder: (context, state, _) {
              return ListView.builder(
                itemCount: state.length,
                itemBuilder: (context, index) {
                  return Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus) state.setFocus(state.typeAt(index));
                    },
                    child: SmartTextField(
                      type: state.typeAt(index),
                      controller: state.textAt(index),
                      focusNode: state.nodeAt(index),
                    ),
                  );
                }
              );
            }
          ),
        ),
        //An option to add a toolbar(use stack instead of column)
        // if(showToolbar) Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: Selector<EditorProvider, SmartTextType>(
        //     selector: (buildContext, state) => state.selectedType,
        //     builder: (context, selectedType, _) {
        //       return Toolbar(
        //         selectedType: selectedType,
        //         onSelected: Provider.of<EditorProvider>(context,
        //           listen: false).setType,
        //       );
        //     },
        //   ),
        // )
      ],
    );
  }

  Widget _expandingCollapsingWidget(){
    return _isCollapsed? 
      GestureDetector(
        onTap: (){
          setState(() {
            _isCollapsed = !_isCollapsed;
          });
        },
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left:15),
          child: Text(
            'CTitle...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 30
            )
          ),
        ),
      )
    :
      Column(
        children:<Widget>[
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            style: TextStyle(
              fontSize: 30
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            // child: FlatButton.icon(
            //   onPressed: (){

            //   },
            //   icon: Icon(Icons.control_point),
            //   label: Row(
            //     children: <Widget>[
            //       Text('asfaf'),
            //       Icon(Icons.ac_unit)
            //     ],
            //   ),
            // ),
            child: FlatButton(
              onPressed: () {

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.face),
                  Text('Admins'),
                  Icon(Icons.add),
                ],
              ),
            ),
          )
        ]
      );
  }
}