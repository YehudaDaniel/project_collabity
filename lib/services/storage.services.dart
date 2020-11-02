// Core
import 'dart:async';
import 'dart:convert';

// Plugins
import 'package:shared_preferences/shared_preferences.dart';

class StorageH {

  static Future<void> setJSON(String key, Map map) async {
    return SharedPreferences.getInstance().then((storageI) {
      storageI.setString(key, json.encode(map));
    });
  }

 static Future<Map<String, dynamic>> getJSON(String key) async {
    return SharedPreferences.getInstance().then((storageI) {
      var encodedJson = storageI.getString(key);

      try {
        if(encodedJson != null) {
          return json.decode(encodedJson);
        } else {
          // Empty json
          return new Map(); 
        }
      } catch(ex) {
        // Empty json
        return new Map();
      }
    });
  }

  static Future<void> remove(String key) async {
    SharedPreferences.getInstance().then((storageI) {
      storageI.remove(key);
    });
  }

  static Future<void> clean() {
    return SharedPreferences.getInstance().then((stroageI) {
      stroageI.clear();
    });
  }

  static Future<void> setOther(String key, something) {
    return SharedPreferences.getInstance().then((storageI) { 
      storageI.setString(key, something.toString());
    });
  }

  static Future getOther(String key) {
    return SharedPreferences.getInstance().then((storageI) {
      return storageI.getString(key);
    });
  }
}

class StoragePaths {
  static final String _dataSaveKey = '@project_collaboty';

  static final String loginCred = '$_dataSaveKey:loginCred';
}