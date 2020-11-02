import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class HttpServices {
  static bool _isDebug = true;
  static String _devUrl = 'http://192.168.1.17:3000';
  static Map<String, String> _defaultHeaders = { 'Content-Type': 'application/json' };

  static String get serverURL {
    return _isDebug ?
      _devUrl
    :
      //if isDebug is false that means we are in production
      'https://real-server.com';
  }

  static Future<bool> login({ Map<String, String> emailPass}) async {
    try {
      http.Response res = await http.post('$serverURL/login', body: emailPass);
      if(res.statusCode == ResponseStatus.Ok){
        return true;

        // if(resBody['email']){
        //   Map<String, dynamic> creds = resBody['cred'];
        //   creds['email'] = emailPass['email'];
        //   creds['password'] = emailPass['password'];

        // }
      }
    } catch(ex) {
      print(ex);
    }
    return false;
  }

  static Future<NewUserCred> register({NewUserCred userCred}) async {
    http.Response res = await http.post('$serverURL/register',
        headers: _defaultHeaders, body: jsonEncode(userCred.toJSON())
      );

    if (res.statusCode == ResponseStatus.Ok) {
      // Map<String, dynamic> resBody = jsonDecode(res.body);

      // if (resBody['isCreated'].toString().toLowerCase() == 'true') {
      //   return NewUserCred.fromJSON(resBody['user']);
      // }

      return null;
    }
    Map<String, dynamic> data = json.decode(res.body);
    //TODO: ask kobe to send back json so I would know what data is taken from the register attempt - Done
    return NewUserCred(NewUserInfo(username: data['isUsernameTaken'], email: data['isEmailTaken']));
  }

  ///A function that asks for the features data to display in a future builder
  static Future<List<Feature>> getFeatures() async {
    var featureData = await http.get('$serverURL/project/features');
    var jsonData = json.decode(featureData.body);

    List<Feature> features = [];
    for(var f in jsonData){
      Feature feature = Feature(f);
      features.add(feature);
    }

    return features;
  }

}

class Feature {
  final String content;

  Feature(this.content);
}

class UserCred {
  String email;
  String password;

  UserCred(
    this.email,
    this.password
  );

  Map<String, dynamic> toJSON() {
    return {
      'email': email,
      'password': password,
    };
  }

  static UserCred fromJSON(Map<String, dynamic> json) {
    try {
      return UserCred(
        json['email'],
        json['password']
      );
    } catch(ex) {
      throw ex;
    }
  }

  @override
  String toString() {
    return toJSON().toString();
  }
}

class NewUserInfo {
  dynamic email;
  dynamic username;
  String password;

  NewUserInfo(
    {
      this.email,
      this.username,
      this.password
    });

  Map<String, String> toJSON() {
    return {
      'email': email,
      'username': username,
      'password': password
    };
  }

  static NewUserInfo fromJSON(Map<String, dynamic> json) {
    return NewUserInfo(
      email: json['email'].toString(),
      username: json['username'].toString(),
      password: json['password'].toString()
    );
  }
}

class NewUserCred {
  NewUserInfo info;

  NewUserCred(this.info);

  Map<String, dynamic> toJSON() {
    return {'info': info.toJSON()};
  }

  static NewUserCred fromJSON(Map<String, dynamic> json) {
    return NewUserCred(
      NewUserInfo.fromJSON(json['info'])
    );
  }

  @override
  String toString() {
    return '{ info: ${info.toString()}';
  }
}

class ResponseStatus {
  static const int NoContent = 204;
  static const int NotFound = 404;
  static const int BadRequest = 400;
  static const int Unauthorized = 401;
  static const int InternalError = 500;
  static const int NotImplemented = 501;
  static const int Ok = 200;
  static const int Created = 201;
  static const int Accepted = 202;
  static const int Found = 302;
}