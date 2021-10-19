import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:public/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class UserRepository {
  Future<User?> authenticate({
    required String email,
    required String password,
  }) async {
    var response = await http.post(Uri.parse(loginURL),
        body: {'email': email, 'password': password});
    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = jsonDecode(response.body);
      final User _user = User.fromJson(userMap);
      if (_user.id == null) {
        print('User ID IS NULL');
        return null;
      } else {

        // final _token = _user.token;
        final _notifications = _user.notifications;
        final _id = _user.id;
        final _email = _user.email;


        SharedPreferences.getInstance().then((prefs) {
          // prefs.setString("user_token", _token!);
          prefs.setString("notifications", json.encode(_notifications));
          prefs.setString("user_id", _id!);
          prefs.setString("user_email", _email!);
          prefs.setBool("is_login", true);
        });
        return _user;
      }
    } else {
      return null;
    }
  }

  

  Future<void> deleteToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("user_token");
    return;
  }

  Future<String?> getId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("user_id");
  }


  Future<String?> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("user_token");
  }

  Future<bool?> isSignedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("is_login");
  }

  Future<dynamic> getUser() async {
    var _token = await getToken();
    var id = await getId();
    var url = Uri.parse(getUserURL + '$id');
    var response = await http
        .get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $_token"});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }


  Future<void> signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    return;
  }

  Future signUp({
      String? email,
      String? password,
      String? confirmPass}) async {
    var response = await http.post(Uri.parse(registerURL), body: {
      'email': email,
      'password': password,
      'confirm_pass': confirmPass
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = jsonDecode(response.body);
      final User _user = User.fromJson(userMap);
      if (_user.id == null) {
        print('User ID IS NULL');
        return null;
      } else {
        // final _token = _user.token;
        final _notifications = _user.notifications;
        final _id = _user.id;
        final _email = _user.email;

        SharedPreferences.getInstance().then((prefs) {
          // prefs.setString("user_token", _token!);
          prefs.setString("notifications", json.encode(_notifications));
          prefs.setString("user_id", _id!);
          prefs.setString("user_email", _email!);
          prefs.setBool("is_login", true);
        });
        return _user;
      }
    }
  }
}
