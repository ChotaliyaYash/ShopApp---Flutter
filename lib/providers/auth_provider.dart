import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/modules/http_exceptions.dart';
import 'package:shopapp/urls/url.dart';

class AuthProvider with ChangeNotifier {
  late String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  Future<void> _authenticationUser(
    String email,
    String password,
    Uri urlSagment,
  ) async {
    try {
      final response = await http.post(
        urlSagment,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HTTPExceprion(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autoLogout();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(URL.signUp);
    return _authenticationUser(email, password, url);
  }

  Future<void> logIn(String email, String password) async {
    final url = Uri.parse(URL.logIn);
    return _authenticationUser(email, password, url);
  }

  Future<void> autoLogout() async {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: timeToExpiry),
      logout,
    );
  }
}
