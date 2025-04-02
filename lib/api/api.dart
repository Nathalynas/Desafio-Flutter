import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:almeidatec/api/api_forgot_password.dart';
import 'package:almeidatec/api/api_signup.dart';
import 'package:almeidatec/models/profile.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'api_interceptor_web.dart'
    if (dart.library.io) 'api_interceptor_mobile.dart';
import 'api_login.dart';

// ignore: constant_identifier_names
const String BASE_URL = String.fromEnvironment(
  'API',
  defaultValue: 'https://estagio.almt.app',
);

class API {
  Dio dio = Dio(BaseOptions(
    baseUrl: BASE_URL,
    connectTimeout: const Duration(minutes: 5),
    receiveTimeout: const Duration(minutes: 5),
    headers: <String, String>{
      "Accept": "application/json",
      'Content-type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    },
  ));
  final CookieInterceptor _cookies = CookieInterceptor();

  static API instance = API();

  static LoginAPI get login => instance._login;
  static SignupAPI get signup => instance._signup;
  static ForgotPasswordAPI get forgotPassword => instance._forgotPassword;


  late LoginAPI _login;
  late SignupAPI _signup;
  late ForgotPasswordAPI _forgotPassword;

  API() {
    dio.interceptors.add(_cookies);
    
    if (!kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () => HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) {
          return <String>{
            'estagio.almt.app',
          }.contains(host);
        };
    }
    _login = LoginAPI(this);
    _signup = SignupAPI(this);
    _forgotPassword = ForgotPasswordAPI(this);
  }

  Codec<String, String> stringToBase64 = utf8.fuse(base64Url);

  Future<ProfileData?> getUserData() async {
    List<Cookie> cookies = await _cookies.getCookies();
    for (Cookie cookie in cookies) {
      if (cookie.name == 'token') {
        List<String> data = cookie.value.split('.');
        if (data.length == 3) {
          String payload = data[1];
          while (payload.length % 4 != 0) {
            payload += "=";
          }
          String encoded = stringToBase64.decode(payload);
          Map<String, dynamic> userData = json.decode(encoded);
          try {
            return ProfileData.fromJson(userData);
          } catch (e, stack) {
            if (kDebugMode) {
              print(e);
              print(stack);
            }
            return null;
          }
        }
      }
    }
    return null;
  }

  String? get currentToken {
    return _cookies.currentCookie;
  }

  static String? get token {
    return instance.currentToken;
  }
}
