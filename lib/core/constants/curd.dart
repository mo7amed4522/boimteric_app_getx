// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Crud {
  Future<dynamic> getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsory = jsonDecode(response.body);
        return responsory;
      } else {
        if (kDebugMode) {
          print("Error ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error Catch $e");
      }
    }
  }

  Future<dynamic> postRequest(String url, Map data) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      debugPrint("Response: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        var responsory = jsonDecode(response.body);
        return responsory;
      } else {
        if (kDebugMode) {
          print("Error ${response.statusCode}");
        }
        return jsonDecode(response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error Catch $e");
      }
      return {"success": false, "error": e.toString()};
    }
  }
}
