import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:project_collabity/utils/User.dart';

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

  ///login post function
  static Future<bool> login({ Map<String, String> emailPass}) async {
    try {
      http.Response res = await http.post(
        '$serverURL/app/login',
        body: emailPass
      );
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

  ///register post function
  static Future<NewUserCred> register({NewUserCred userCred}) async {
    http.Response res = await http.post(
      '$serverURL/app/register',
      headers: _defaultHeaders,
      body: jsonEncode(userCred.toJSON())
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

  //A function for sending the data of a new project creation
  static Future<NewProjectData> createProject({ NewProjectData project }) async {
    http.Response res = await http.post(
      '$serverURL/project/createProject',
      headers: _defaultHeaders,
      body: jsonEncode(project.toJSON())
    );

    if(res.statusCode == ResponseStatus.Ok){
      return null;
    }
    // Map<String, dynamic> data = json.decode(res.body);
    return NewProjectData();
  }

  ///projects list get function
  static Future<List<ProjectData>> projectsList({ProjectData projectData}) async {
    http.Response res = await http.get('$serverURL/app/project');
    var jsonData = json.decode(res.body);

    List<ProjectData> projects = [];
    for(var f in jsonData){
      ProjectData project = ProjectData(f['title'], f['collaborators'], f['content']);
      projects.add(project);
    }

    return projects;
  }

  static List<User> parseUsers(String resBody){
    final parsed = json.decode(resBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  //A function that gets collaborators from the server for adding to the project(ModalBottomSheet).
  static Future<List<User>> getCollaborators() async {
    try{
      final res = await http.get('http://jsonplaceholder.typicode.com/users');
      if(res.statusCode == 200){
        List<User> list = parseUsers(res.body);
        return list;
      }else{
        throw Exception('Error');
      }
    }catch(ex){
      throw Exception(ex.toString());
    }
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


//User credentials for logging in
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

//A new user info for a new sign up
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
//New user credentials creation
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

//A new project creation
class NewProjectData {
  String title;
  List<String> collabsList;
  List<Map<String, String>> content;

  NewProjectData({
    this.title,
    this.collabsList,
    this.content
  });

    Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'collabsList': collabsList,
      'content': content
    };
  }

  static NewProjectData fromJSON(Map<String, dynamic> json) {
    try {
      return NewProjectData(
        title: json['title'].toString(),
        collabsList: json['collabsList'],
        content: json['content'.toString()]
      );
    } catch(ex) {
      throw ex;
    }
  }
}

class Feature {
  final String content;

  Feature(this.content);
}

class ProjectData {
  final String title;
  final List<dynamic> collabsList;
  final String content;

  ProjectData(this.title, this.collabsList, this.content);
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