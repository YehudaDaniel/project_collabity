//USAGE: the text editor page, creating a new project.
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:project_collabity/pages/TextEditorWidget/statemanage.pages.dart';
import 'package:project_collabity/pages/TextEditorWidget/textField.pages.dart';
import 'package:project_collabity/widgets/ModalTriggetButton.dart';
import 'package:provider/provider.dart';

class TextEditorPage extends StatefulWidget {
  TextEditorPage({Key key}) : super(key: key);

  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
  
  final _focusNode = FocusNode();

  TextEditingController _textEditingController = TextEditingController();
  bool _isCollapsed = true;
  bool showToolbar = false;

  String _title = '';
  List<String> content = [];


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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditorProvider>(
      create: (context) => EditorProvider(),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: InkWell( // a button on the whole screen to blur the textfields on tap.
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                if(_focusNode.hasFocus){
                  setState(() {
                    _isCollapsed = !_isCollapsed; // when the user taps on the inkwell, the collapsingwidget would close.
                  });
                }
              },
              child: Column(
                children:<Widget>[
                  Container(
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed:() {
                            if(_isCollapsed){
                              // if the collapsingwidget is collapsed, the button would be used to go back to the projects list page.
                            }else{
                              setState(() {
                                _isCollapsed = !_isCollapsed; // otherwise it would be used to collapse the widget.
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
                            // when the user done creating the project, a test will run on the data and a new project would be created.
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
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey[200],
                    child: _expandingCollapsingWidget() // the expanding and collapsing widget at the top of the screen.
                  ),
                  Expanded(child: _textEditorWidget()) // the special text editor under the collapsingWidget.
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  // The text editor widget, creates the text editor with the textfields.
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
                      change: (value) {
                        content.add(value);
                        print(content); 
                      },
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

  // The expanding and collapsing widget.
  Widget _expandingCollapsingWidget(){
    return _isCollapsed? 
      GestureDetector(
        onTap: (){
          _focusNode.requestFocus();
          setState(() {
            _isCollapsed = !_isCollapsed;
          });
        },
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left:15),
          child: (_title.length > 0)? Text(
              _title,
              style: TextStyle(
                fontSize: 30
              )
            )
          :
            Text(
              'Title...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 30
              )
            )
        ),
      )
    :
      Column(
        children:<Widget>[
          TextField(
            focusNode: _focusNode,
            onChanged: (title) =>  setState(() => _title = title),
            autofocus: true,
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
            child: FlatButton(
              onPressed: () {

              },
              child: Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                child: ModalTriggerButton()
              )
            ),
          )
        ]
      );
  }

  @override
  void dispose(){
    KeyboardVisibilityNotification().dispose();
    super.dispose();
  }
}