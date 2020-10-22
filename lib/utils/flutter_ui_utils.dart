// Core
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Plugins
import 'package:progress_hud/progress_hud.dart';

class Dialogs {

  static bool _isSpinnerShown = false;

  /// Shows a basic alert with Ok button on it
  ///
  /// `context` The context of your current page
  ///
  /// `body` The body of the dialog
  ///
  /// `buttonName` The name of the button hides the dialog. Default is OK
  ///
  /// `onResolve` CallBack function that calls back when hit the resolve button
  ///
  /// `onDismiss` CallBack function that calls back
  /// when the dialog dismissed = not hit OK
  static void showAlert( BuildContext context, String body, {
    String title = 'Alert',
    String buttonName = 'OK',
    Function onResolve,
    Function onDismiss,
    bool showCancelButton = false
  }) {
    bool clicked = false;
    if(_isSpinnerShown) {
      hideLoadingSpinner(context);
    }

    AlertDialog dialog = new AlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: <Widget>[
          new FlatButton(child: new Text(buttonName), onPressed: () {
            Navigator.of(context).pop(); // Hides the Alert
            clicked = true;

            if(onResolve != null) {
              onResolve();
            }
          }),
          showCancelButton ?
          new FlatButton(child: new Text('Cancel'), onPressed: () {
            Navigator.of(context).pop(); // Hides the Alert
            clicked = true;

            if(onDismiss != null){
              onDismiss();
            }
          })
              :
          SizedBox()
        ]
    );

    showDialog(context: context, builder: (BuildContext context) => dialog).then((val) {
      if(!clicked) {
        if(onDismiss != null){
          onDismiss();
        }
      }
    });
  }

  /// Show a dialog with loading circle indicator
  ///
  /// `context` The context of your current page
  ///
  /// `secondsToHide` The number of seconds the dialog shown. Default is 30sec
  ///
  /// `backgroundColor` Background color of the rest of the screen except dialog
  ///
  /// `color` Color of the text
  ///
  /// `containerColor` Color of the dialog itself
  ///
  /// `borderRadius` The angle of circular border of the dialog
  ///
  /// `text` Text written by the dialog
  static void showLoadingSpinner(BuildContext context, {
    int secondsToHide = 30,
    Color backgroundColor,
    Color color,
    Color containerColor,
    double borderRadius,
    String text
  }) {
    if(_isSpinnerShown) {
      hideLoadingSpinner(context);
    }

    ProgressHUD progressSpinner = ProgressHUD(
        backgroundColor: backgroundColor != null ? backgroundColor : Colors.black12,
        color: color != null ? color : Theme.of(context).primaryColorLight,
        containerColor: containerColor != null ? containerColor : Colors.transparent,
        borderRadius: borderRadius != null ? borderRadius : 5.0,
        text: text != null || text != '' ? text : 'Loading...'
    );

    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => progressSpinner);
    _isSpinnerShown = true;

    // This is like setTimeout in JavaScript
    Future.delayed(Duration(seconds: secondsToHide), () => hideLoadingSpinner(context));
  }

  /// Hides the loading dialog manually
  ///
  /// `context` The same context received by the showLoadingSpinner function
  static void hideLoadingSpinner(BuildContext context) {
    if(_isSpinnerShown){
      Navigator.pop(context);

      // Toggle to false the flag of the loading spinner
      _isSpinnerShown = false;
    }
  }

  /// Showing a dialog with multiple buttons with custom functions in each
  ///
  /// `context` The context of your current page
  ///
  /// `body` The body of the confirm alert
  ///
  /// `title` The title you want to write on
  ///
  /// `buttons` Map<String, Function> - The name of the button (String),
  /// The function that you want to run after (Function)
  static void confirmDialog(BuildContext context, String body, String title,
      { Map<String, Function> buttons, bool showCancelButton = false }
      ) {
    if(_isSpinnerShown) {
      hideLoadingSpinner(context);
    }

    List<Widget> widgetArr = [];
    if(buttons.isNotEmpty) {
      buttons.forEach((buttonName, funToRun) {
        widgetArr.add(
            new FlatButton(child: Text(buttonName), onPressed: () {
              // Running the function that commited to this button
              funToRun();
              Navigator.of(context).pop(); // Hides the Alert
            })
        );
      });
    } else {
      widgetArr[0] = new FlatButton(child: Text('OK'), onPressed: () {
        Navigator.of(context).pop(); // Hides the Alert
      });

      if(showCancelButton) {
        widgetArr[1] = new FlatButton(child: Text('Cancel'), onPressed: () {
          Navigator.of(context).pop(); // Hides the Alert
        });
      }
    }

    AlertDialog dialog = new AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: widgetArr
    );
    showDialog(context: context, child: dialog);
  }

  /// Showing propmt dialog, which is a dialog with textField inside it
  ///
  /// `context` The context of the page you call from
  ///
  /// `title` The title of the dialog
  ///
  /// `body` The body of the dialog (text on top of the textField)
  ///
  /// `placeholder` A text that written in the TextField and
  ///  disapears when the user start to type
  ///
  /// `textCtrl` A custom text controller
  ///
  /// `keyboardType` The type of the keyboard (such as email, numbers)
  ///  default is text
  ///
  /// `showCancelButton` A switch you can set,
  /// if you want to see the Cancel button of the dialog. default is false
  static Future<String> propmt(
      BuildContext context, String title, String body, String placeholder,
      { TextEditingController textCtrl, TextInputType keyboardType = TextInputType.text, bool showCancelButton = false }
      ) {
    if(_isSpinnerShown) {
      hideLoadingSpinner(context);
    }

    String data;
    bool isOk = false;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(title),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 25, bottom: 5),
                    child: Text(body)
                ),
                Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                    child: TextField(
                        controller: textCtrl,
                        autofocus: true,
                        keyboardType: keyboardType,
                        decoration: InputDecoration(
                            hintText: placeholder
                        ),
                        onChanged: (text) => data = text
                    )
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                          child: Text('OK'),
                          onPressed: () {
                            isOk = true;
                            Navigator.of(context).pop();
                          }
                      ),
                      showCancelButton ?
                      FlatButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            isOk = false;
                            Navigator.of(context).pop();
                          }
                      )
                          :
                      SizedBox()
                    ]
                )
              ]
          );
        }
    ).then((val) {
      if(isOk && (data != null || data != '')) {
        return data;
      }
      return null;
    });
  }
}

class FavoritesWidgets {
  /// Create an appbar with subtitle in it
  ///
  /// `bar` Your [AppBar] with anything you want inside it
  ///
  /// `title` The title of the AppBar
  ///
  /// `subtitle` The subtitle that under the title
  ///
  /// `textColor` The color of the title and subtitle
  ///
  /// `titleFontSize` The custom size of the title
  ///
  /// `subtitleFontSize` The custom size of the subtitle
  static AppBar appBarWithSubtitle(
      AppBar bar, String title, String subtitle,
      { Color textColor, double titleFontSize = 18, double subtitleFontSize = 12 }
      ) {
    return AppBar(
        title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  title,
                  style: TextStyle(
                      color: textColor != null ? Colors.white : textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize != 0 ? titleFontSize : 18
                  )
              ),
              Text(
                  subtitle,
                  style: TextStyle(
                      color: textColor != null ? Colors.white : textColor,
                      fontSize: subtitleFontSize != 0 ? subtitleFontSize : 12
                  )
              )
            ]
        ),
        leading: bar.leading != null ?
        Padding(padding: const EdgeInsets.all(5.0), child: bar.leading)
            :
        bar.leading
        ,
        actions: bar.actions,
        actionsIconTheme: bar.actionsIconTheme,
        automaticallyImplyLeading: bar.automaticallyImplyLeading,
        backgroundColor: bar.backgroundColor,
        bottom: bar.bottom,
        bottomOpacity: bar.bottomOpacity,
        brightness: bar.brightness,
        centerTitle: bar.centerTitle,
        elevation: bar.elevation,
        flexibleSpace: bar.flexibleSpace,
        iconTheme: bar.iconTheme,
        key: bar.key,
        primary: bar.primary,
        shape: bar.shape,
        textTheme: bar.textTheme,
        titleSpacing: bar.titleSpacing,
        toolbarOpacity: bar.toolbarOpacity
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  /// Getting the hex string from a Color class
  ///
  /// `c` const dart [Color]
  static String getHexFromColor(Color c) {
    String hexVal = c.value.toRadixString(16);
    return '#$hexVal';
  }

  /// Use `hexColor` hex string instead of the dart's [Color] class
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}