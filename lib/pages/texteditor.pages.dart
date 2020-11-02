import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class TextEditorPage extends StatefulWidget {
  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
  
  TextEditingController _textEditingController = TextEditingController();
  bool _isCollapsed = true;
  // FocusNode _titleFocus;

  //Allows to control the editor and the document
  ZefyrController _controller;
  //FocusNode for the Zefyr text editor input node
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    //We must load the document and pass it to Zefyr controller
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();

  }
  
  //Load the document to be edited on Zefyr
  NotusDocument _loadDocument(){
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children:<Widget>[
                Expanded(
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
                Expanded(
                  flex: 1,
                  child: _expandingCollapsingWidget(),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.grey[200],
                    child: ZefyrScaffold(
                      child: ZefyrEditor(
                        padding: EdgeInsets.all(16),
                        controller: _controller,
                        focusNode: _focusNode,
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      )
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
            child: FlatButton.icon(
              
              onPressed: (){

              },
              icon: Icon(Icons.control_point),
              label: Row(
                children: <Widget>[
                  Text('asfaf'),
                  Icon(Icons.ac_unit)
                ],
              ),
            ),
          )
        ]
      );
  }
}