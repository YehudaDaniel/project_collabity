import 'package:flutter/material.dart';
import 'package:project_collabity/utils/ui.utils.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  bool _isLoginActive;
  AnimationController _controller;
  Animation _animation;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _isLoginActive = true;

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SafeArea(
                  child: Center(
                    child: Icon(
                      Icons.lightbulb_outline,
                      size: 150,
                      color: HexColor('#88d5cb'),
                    ),
                  ),
                ),
                Container(
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            textColor:
                                _isLoginActive ? Colors.black : Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(10),
                            splashColor: Colors.grey,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: _isLoginActive
                                      ? MediaQuery.of(context).size.width * 0.10
                                      : MediaQuery.of(context).size.width * 0.07,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: !_isLoginActive
                                ? () {
                                    setState(() {
                                      _isLoginActive = !_isLoginActive;
                                    });
                                  }
                                : null,
                          ),
                          FlatButton(
                            textColor:
                                !_isLoginActive ? Colors.black : Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(10),
                            splashColor: Colors.grey,
                            child: Text(
                              'SignUp',
                              style: TextStyle(
                                  fontSize: !_isLoginActive
                                      ? MediaQuery.of(context).size.width * 0.10
                                      : MediaQuery.of(context).size.width * 0.07,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: _isLoginActive
                                ? () {
                                    setState(() {
                                      _isLoginActive = !_isLoginActive;
                                    });
                                  }
                                : null,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                login(),
                roundedButton('LOGIN'),
              ],
            ),
          ),
        ),
      ));
  }

  ///Building the Email input for using in the Login and SignUp
  Widget buildEmail() {
    Color borderCo = HexColor('#88d5cb');

    return Container(
      padding: EdgeInsets.only(top: 35, left: 20, right: 20),
      child: Column(
        children: <Widget>[
          TextField(
            // focusNode: _focusNode,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: borderCo)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: borderCo)),
              labelText: 'Email',
              labelStyle: TextStyle(
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              )
            ),
          )
        ],
      )
    );
  }

  ///Building the Email input for using in the Login and SignUp
  Widget buildPassword() {
    Color borderCo = HexColor('#88d5cb');

    return Container(
        padding: EdgeInsets.only(top: 35, left: 20, right: 20),
        child: Column(
          children: <Widget>[
            TextField(
              focusNode: _focusNode,
              obscureText: true,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: borderCo)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: borderCo)),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  )),
            )
          ],
        ));
  }

  ///Building the login Container which would be in an animated container for switching between the SignUp
  Widget login() {
    return Container(
        child: Column(
      children: <Widget>[buildEmail(), buildPassword()],
    ));
  }

  ///Building a rounded button for future use in code
  Widget roundedButton(String text){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical:30),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: HexColor('#88d5cb')),
        borderRadius: BorderRadius.circular(20.0),
        ),
        height: 50.0,
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          elevation: 1,
          child: GestureDetector(
            onTap: () {},
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                  fontSize: 20,
                )
              )
            )
          )
        )
      ),
    );
  }
}
