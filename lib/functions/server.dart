import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lancamentost12/constants.dart';

Future<http.Response> post(String URL, Map body) async {
  try {
    var preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token');
    final String ip = preferences.getString('ip');

    var response = await http.post("http://" + ip + SERVER_PORT + URL,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Token': 'Bearer $token'
        },
        body: jsonEncode(body));
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<http.Response> put(String URL, String id, Map body) async {
  try {
    var preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token');
    final String ip = preferences.getString('ip');

    var response = await http.put("http://" + ip + SERVER_PORT + URL + '/' + id,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Token': 'Bearer $token'
        },
        body: jsonEncode(body));
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<http.Response> get(String URL) async {
  try {
    var preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token');
    final String ip = preferences.getString('ip');

    var response = await http.get("http://" + ip + SERVER_PORT + URL, headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Token': 'Bearer $token'
    });
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<http.Response> login(String ip, Map body) async {
  try {
    var response = await http.post("http://" + ip + SERVER_PORT + URL_LOGIN,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode(body));
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}
