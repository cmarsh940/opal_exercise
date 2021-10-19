import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class NotificationRepository {
  Future<String?> getId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("user_id");
  }

  Future<String?> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("user_token");
  }

  Future<dynamic> getNotifications() async {
    var _token = await getToken();
    var id = await getId();
    var url = Uri.parse(getNotificationsURL + '$id');
    var response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<dynamic> addNotification() async {
    var _token = await getToken();
    var id = await getId();
    var url = Uri.parse(addNotificationURL + '$id');
    var response = await http
        .post(url, headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }
}
