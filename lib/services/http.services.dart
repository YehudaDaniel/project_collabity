// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:project_collabity/services/storage.services.dart';

// class HttpServices {
//   static bool _isDebug = true;
//   static String _devURL = '192.168.1.19:3000';
//   static Map<String, String> _defaultHeaders = {
//     'Content-Type' : 'application/json'
//   };

//   static String get serverURL {
//     return _isDebug
//     ? _devURL
//     :
//     //Production Server
//     'https://real-server.com';
//   }

//   static Future<bool> login({Map<String, String> emailPass}) async {
//     try {
//       http.Response res = await http.post('$serverURL/login', body: emailPass);
//       if (res.statusCode == ResponseStatus.Ok) {
//         Map<String, dynamic> resBody = jsonDecode(res.body);

//         if (resBody['auth'].toString().toLowerCase() == 'true') {
//           Map<String, dynamic> creds = 

//           StorageH.setJSON(
//               StoragePaths.LoginCred, UserCred.fromJSON(creds).toJSON());
//           return true;
//         }
//       }
//     } catch (ex) {
//       print(ex);
//     }
//     return false;
//   }

//   static Future<NewUserCred> register({NewUserCred userCred}) async {
//     http.Response res = await http.post('$serverURL/register',
//         headers: _defaultHeaders, body: jsonEncode(userCred.toJSON()));

//     if (res.statusCode == ResponseStatus.Ok) {
//       Map<String, dynamic> resBody = jsonDecode(res.body);

//       if (resBody['isCreated'].toString().toLowerCase() == 'true') {
//         return NewUserCred.fromJSON(resBody['user']);
//       }
//     }

//     return null;
//   }

// }

// class NewUserData {
//   String password;
//   String pinCode;

//   NewUserData({this.password, this.pinCode});

//   Map<String, String> toJSON() {
//     return {'password': password, 'pinCode': pinCode};
//   }

//   static NewUserData fromJSON(Map<String, dynamic> json) {
//     return NewUserData(
//         password: json['password'].toString(),
//         pinCode: json['pinCode'].toString());
//   }
// }

// class NewUserInfo {
//   String email;
//   String username;

//   NewUserInfo(
//     {
//       this.email,
//       this.username
//     }
//   );

//   Map<String, String> toJSON() {
//     return {
//       'email': email,
//       'username': username
//     };
//   }

//   static NewUserInfo fromJSON(Map<String, dynamic> json) {
//     return NewUserInfo(
//         email: json['email'].toString(),
//         username: json['username'].toString()
//       );
//   }

//   @override
//   String toString() {
//     return '''{ 
//       email: ${email.toString()}, 
//       username: ${username.toString()}
//     }''';
//   }
// }

// class NewUserCred {
//   NewUserData data;
//   NewUserInfo info;

//   NewUserCred(this.data, this.info);

//   Map<String, dynamic> toJSON() {
//     return {'data': data.toJSON(), 'info': info.toJSON()};
//   }

//   static NewUserCred fromJSON(Map<String, dynamic> json) {
//     return NewUserCred(
//         NewUserData.fromJSON(json['data']), NewUserInfo.fromJSON(json['info']));
//   }

//   @override
//   String toString() {
//     return '{ data: ${data.toString()}, info: ${info.toString()}';
//   }
// }

// class User {
//   String email;
//   String username;
//   String password;
//   String profileImage;
//   int lastConnected;

//   User(
//     {
//       this.username,
//       this.password,
//       this.email,
//       this.profileImage,
//       this.lastConnected
//     }
//   );

//   Map<String, dynamic> toJSON() {
//     return {
//       'username': username,
//       'password': password,
//       'email': email,
//       'profileImage': profileImage,
//       'lastConnected': lastConnected
//     };
//   }

//   static User fromJSON(Map<String, dynamic> json) {
//     return User(
//         username: json['username'],
//         password: json['password'],
//         email: json['email'],
//         profileImage: json['profileImage'],
//         lastConnected: json['lastConnected']);
//   }

//   @override
//   String toString() {
//     return toJSON().toString();
//   }
// }

// class UserCred {
//   // username password of client
//   String email;
//   String password;

//   UserCred(this.email, this.password);

//   Map<String, dynamic> toJSON() {
//     return {
//       'email': email,
//       'password': password,
//     };
//   }

//   static UserCred fromJSON(Map<String, dynamic> json) {
//     try {
//       return UserCred(
//           json['email'],
//           json['password']
//         );
//     } catch (ex) {
//       throw ex;
//     }
//   }

//   @override
//   String toString() {
//     return toJSON().toString();
//   }
// }

// class ResponseStatus {
//   static const int NoContent = 204;
//   static const int NotFound = 404;
//   static const int BadRequest = 400;
//   static const int Unauthorized = 401;
//   static const int InternalError = 500;
//   static const int NotImplemented = 501;
//   static const int Ok = 200;
//   static const int Created = 201;
//   static const int Accepted = 202;
//   static const int Found = 302;
// }


import 'dart:convert';
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

  static Future<bool> login({ Map<String, String> emailPass }) async {
    
    try {
      http.Response res = await http.post('$serverURL/login', body: emailPass);
      if(res.statusCode == ResponseStatus.Ok){
        Map<String, dynamic> resBody = jsonDecode(res.body);
      }
    } catch(ex) {
      print(ex);
    }
    return false;
  }

  static Future<NewUserCred> register({NewUserCred userCred}) async {
    http.Response res = await http.post('$serverURL/register',
        headers: _defaultHeaders, body: jsonEncode(userCred.toJSON()));

    if (res.statusCode == ResponseStatus.Ok) {
      Map<String, dynamic> resBody = jsonDecode(res.body);

      if (resBody['isCreated'].toString().toLowerCase() == 'true') {
        return NewUserCred.fromJSON(resBody['user']);
      }
    }

    return null;
  }

}

class UserCred {
  String name;
  String password;

  UserCred(
    this.name,
    this.password
  );

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'password': password,
    };
  }

  static UserCred fromJSON(Map<String, dynamic> json) {
    try {
      return UserCred(
        json['name'],
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

class NewUserData {
  String password;

  NewUserData({this.password});

  Map<String, String> toJSON() {
    return {'password': password};
  }

  static NewUserData fromJSON(Map<String, dynamic> json) {
    return NewUserData(
        password: json['password'].toString()
      );
  }
}

class NewUserInfo {
  String email;
  String username;

  NewUserInfo(
    {
      this.email,
      this.username
    });

  Map<String, String> toJSON() {
    return {
      'email': email,
      'username': username
    };
  }

  static NewUserInfo fromJSON(Map<String, dynamic> json) {
    return NewUserInfo(
        email: json['email'].toString(),
        username: json['username'].toString()
      );
  }
}

class NewUserCred {
  NewUserData data;
  NewUserInfo info;

  NewUserCred(this.data, this.info);

  Map<String, dynamic> toJSON() {
    return {'data': data.toJSON(), 'info': info.toJSON()};
  }

  static NewUserCred fromJSON(Map<String, dynamic> json) {
    return NewUserCred(
        NewUserData.fromJSON(json['data']), NewUserInfo.fromJSON(json['info']));
  }

  @override
  String toString() {
    return '{ data: ${data.toString()}, info: ${info.toString()}';
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