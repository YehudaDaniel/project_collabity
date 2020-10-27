import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:project_collabity/pages/collabityHome.pages.dart';
import 'package:project_collabity/services/http.services.dart';
import 'package:project_collabity/utils/flutter_ui_utils.dart';
import 'package:project_collabity/widgets/buildInput.widgets.dart';
import 'package:project_collabity/widgets/buttons.widgets.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  bool swap = true;
  bool _isLoginActive;
  AnimationController _controller;
  String err = '';
  
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
                            textColor: _isLoginActive ? Colors.black : Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(10),
                            splashColor: Colors.grey,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: _isLoginActive ? 
                                            MediaQuery.of(context).size.width * 0.10
                                          : 
                                            MediaQuery.of(context).size.width * 0.07,
                                fontWeight: FontWeight.bold),
                            ),
                            onPressed: !_isLoginActive
                                ? () {
                                    setState(() {
                                      _isLoginActive = !_isLoginActive;
                                      swap = !swap;
                                      err = '';
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
                                      err = '';
                                    });
                                  }
                                : null,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      err,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red
                      )
                    )
                  ),
                ),
                swap? loginWidget(size) : signupWidget(size),
                SizedBox(height: 20,),
              ]
            )
          )
        )
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
          SizedBox(height: 15,),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: RaisedButton(
              disabledColor: Colors.grey[300],
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'LOGIN',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: HexColor('#88d5cb')),
                ),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: HexColor('#88d5cb')),
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: (EmailValidator.validate(_loginEmail) && _loginPassword.length >= 6) ?() async {
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
                      // Dialogs.showAlert(context, 'Email or password incorrect, try again.');
                      setState(() {
                        err = "The email or password you've entered doesn't match any account.";
                      });
                      print(err);
                    }
                  } catch(ex) {
                    print('login ex: $ex');
                  }
                }
                :
                null
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
            change: (aa) => setState(() => _signupRepeat = aa)
          ),
          SizedBox(height: 15,),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: RaisedButton(
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'SIGNUP',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: HexColor('#88d5cb')),
                ),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: HexColor('#88d5cb')),
                borderRadius: BorderRadius.circular(10.0)
              ),
              onPressed: () async {
                Dialogs.showLoadingSpinner(context);
                if(check()){
                  NewUserCred user = await HttpServices.register(
                    userCred: NewUserCred(
                      NewUserInfo(
                        email: _signupEmail,
                        username: _signupUsername,
                        password: _signupPassword
                      )
                    )
                  );
                  Dialogs.hideLoadingSpinner(context);
                  if(user == null) { 
                    Dialogs.hideLoadingSpinner(context);
                    setState(() {
                      err = '';
                    });
                    Dialogs.showAlert(context, 'Registered successfully');
                    setState(() {
                      _isLoginActive = !_isLoginActive;
                      swap = !swap;
                    });
                  } else { 
                    Dialogs.hideLoadingSpinner(context);
                    setState(() {
                      err = 'User already taken.';
                    });
                  }
                } else {
                  Dialogs.hideLoadingSpinner(context);
                  print(_signupEmail);
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
    if(!EmailValidator.validate(_signupEmail)) {
      setState(() {
        err = 'Make sure Email is valid.';
      });
      res = false;
    }
    if(_signupUsername.length < 3) {
      setState(() {
        err = 'Username must be at least 3 characters.';
      });
      res = false;
    }
    if(_signupPassword.length < 6) {
      setState(() {
        err = 'Password must be at least 6 characters.';
      });
      res = false;
    }
    if(_signupRepeat != _signupPassword){
      setState(() {
        err = 'Please repeat an identical password.';
      });
      res = false;
    }
    return res;
  }
}
