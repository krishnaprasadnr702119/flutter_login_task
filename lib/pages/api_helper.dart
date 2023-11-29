import 'package:http/http.dart' as http;
import 'package:newlogin/pages/coverpage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ApiHelper {
  static Future<String?> getStoredAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  static Future<String?> getStoredRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  static Future<void> storeAccessToken(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
  }

  static Future<void> storeRefreshToken(String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('refreshToken', refreshToken);
  }

  static Future<void> removeTokens() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  static Future<Map<String, dynamic>?> refreshToken(
      String refreshToken, BuildContext context) async {
    const String refreshUrl = 'http://192.168.4.166:3001/refresh';

    try {
      final response = await http.post(
        Uri.parse(refreshUrl),
        headers: {
          'Authorization': 'Bearer $refreshToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        await storeAccessToken(responseData['accessToken']);
        await storeRefreshToken(responseData['refreshToken']);
        return responseData;
      } else if (response.statusCode == 401) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CoverPage()));
        return null;
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CoverPage()));
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> signIn(
      String email, String password) async {
    const String loginUrl = 'http://192.168.4.166:3001/login';

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        await storeAccessToken(responseData['accessToken']);
        await storeRefreshToken(responseData['refreshToken']);
        return responseData;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> signUp(
      String email, String name, String password) async {
    const String signupUrl = 'http://192.168.4.166:3001/signup';

    try {
      final response = await http.post(
        Uri.parse(signupUrl),
        body: jsonEncode({
          'email': email,
          'name': name,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<String?> getProtectedData(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        print('Access token not found. Please sign in.');
        return null;
      }

      final response = await http.get(
        Uri.parse('http://192.168.4.166:3001/protected'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final protectedData = response.body;
        // print('Protected data: $protectedData');
        return protectedData;
      } else {
        // print(
        //     'Error getting protected data - Status Code: ${response.statusCode}');
        // print('Response body: ${response.body}');

        // Navigate to CoverPage if status code is not 200
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CoverPage()),
        );
        return null;
      }
    } catch (error) {
      //print('Error getting protected data: $error');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CoverPage()),
      );
      return null;
    }
  }
}
