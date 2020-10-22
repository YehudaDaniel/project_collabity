import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:project_collabity/pages/collabityHome.pages.dart';
import 'package:project_collabity/services/http.services.dart';
import 'package:project_collabity/utils/flutter_ui_utils.dart';
import 'package:project_collabity/widgets/buttons.utils.dart';
import 'package:project_collabity/widgets/buildInput.utils.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  bool swap = true;
  bool _isLoginActive;
  AnimationController _controller;
  
  //Variables for login
  String _loginEmail = '';
  String _loginPassword = '';

  //Variables for sign up
  String _signupEmail = '';
  String _signupUsername = '';
  String _signupPassword = '';
  String _signupRepeat = '';

  @override
  void initState() {
    super.initState();

    _isLoginActive = true;
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                                      swap = !swap;
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
                                      swap = !swap;
                                    });
                                  }
                                : null,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                swap? loginWidget(size) : signupWidget(size),
              ]
            )
          )
        )
      )
    );
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
              prefixIcon: Icon(Icons.mail),
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

  /// Building the login Widget Container which would be in an animated container for switching between the SignUp
  Widget loginWidget(size) {
    return Container(
      child: Column(
        children: <Widget>[
          buildInput(
            obscureText: false, 
            icon: Icons.mail, 
            labelText:'EMAIL', 
            change: (login) => setState(() => _loginEmail = login)
          ),
          buildInput(
            obscureText:true, 
            icon:Icons.lock, 
            labelText:'PASSWORD',
            change: (login) => setState(() => _loginPassword = login)
          ),
          SizedBox(
            child: RaisedButton(
              child: Text(
                'LOGIN'
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: () async {
                  try {
                    Dialogs.showLoadingSpinner(context);
                    bool isLoggedIn = await HttpServices.login(emailPass: { 
                      'email': _loginEmail, 
                      'password': _loginPassword 
                    });

                    if(isLoggedIn) { 
                      Dialogs.hideLoadingSpinner(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => CollabityHome()
                        )
                      );
                    } else { 
                      Dialogs.hideLoadingSpinner(context);
                      Dialogs.showAlert(context, 'There is no data to show');
                    }
                  } catch(ex) {
                    print('login ex: $ex');
                  }
                }
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildAuth('assets/images/google_logo.png', size),
              buildAuth('assets/images/facebook_logo.png', size)
            ],
          )
        ],
      )
    );
  }

  ///Building the SignUp Widget Container which would be in an animated container for switching between the Login
  Widget signupWidget(size) {
    return Container(
      child: Column(
        children: <Widget>[
          buildInput(
            obscureText:false, 
            icon:Icons.mail, 
            labelText:'Email',
            change: (signup) => setState(() => _signupEmail = signup)
          ),
          buildInput(
            obscureText:false, 
            icon:Icons.account_circle, 
            labelText:'USERNAME',
            change: (signup) => setState(() => _signupUsername = signup)
          ),
          buildInput(
            obscureText:true, 
            icon:Icons.lock, 
            labelText:'PASSWORD',
            change: (signup) => setState(() => _signupPassword = signup)
          ),
          buildInput(
            obscureText:true, 
            icon:Icons.lock, 
            labelText:'REPEAT PASSWORD',
            change: (signup) => setState(() => _signupRepeat = signup)
          ),
          SizedBox(
            child: RaisedButton(
              child: Text(
                'SIGNUP'
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              onPressed: () async {
                Dialogs.showLoadingSpinner(context);
                if(check()) {
                  NewUserCred user = await HttpServices.register(
                    userCred: NewUserCred(
                      NewUserData(password: _signupPassword),
                      NewUserInfo(
                        email: _signupEmail,
                        username: _signupUsername
                      )
                    )
                  );
                  Dialogs.hideLoadingSpinner(context);
                  Dialogs.showAlert(context, "Try Again");
                  if(user == null) { 
                    Dialogs.hideLoadingSpinner(context);
                    Dialogs.showAlert(context, 'Registered successfully');
                    Navigator.of(context).push(MaterialPageRoute(
                      builder:(BuildContext context) => CollabityHome())
                    );
                  } else { 
                    Dialogs.hideLoadingSpinner(context);
                    Dialogs.showAlert(context, 'There is no data to show');
                  }
                } else {
                  Dialogs.hideLoadingSpinner(context);
                  Dialogs.showAlert(context, "Please check again all fields");
                  print(check());
                }
              }
            )
          )
        ],
      )
    );
  }

  ///checks if all of the input's values are valid and return true if they are
  bool check() {
    bool res = true;
    // if(!EmailValidator.validate(_signupEmail)) {
    //   print('Email is not valid');
    //   res = false;
    // }
    if(_signupPassword.length < 6  && _signupPassword != _signupRepeat) {
      print('Password is not valid');
      res = false;
    }
    if(_signupUsername.length < 3) {
      print('Username is not valid');
      res = false;
    }
    return res;
  }
}
