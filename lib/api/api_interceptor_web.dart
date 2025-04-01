// ignore_for_file: avoid_web_libraries_in_flutter

// ignore: deprecated_member_use
import 'dart:html' as html;
import 'package:almeidatec/main.dart';
import 'package:dio/dio.dart';
import 'package:almeidatec/routes.dart';

class Cookie {
  final String name, value;

  Cookie(this.name, this.value);
}

class CookieInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.extra['withCredentials'] = true;
    List<Cookie> cookies = await getCookies();
    for (Cookie cookie in cookies) {
      if (cookie.name == 'token') {
        currentCookie = cookie.value;
        break;
      }
    }
    handler.next(options);
  }

  String? currentCookie;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null) {
      Response<dynamic> response = err.response!;
      try {
        if (response.statusCode == 403) {
          await deleteCookie();
          MyApp.appStateKey.currentState?.pushNamed(Routes.login);
        } 
      } catch (e, stack) {
        err = DioException(
          requestOptions: response.requestOptions,
          error: e,
          stackTrace: stack,
        );
      }
    }
    handler.next(err);
  }

  Cookie __cookieFromString(String txt) {
    List<String> values = txt.split('=');
    return Cookie(values[0], values.sublist(1).join('='));
  }

  Future<List<Cookie>> getCookies() async {
    List<String> cookies =
        html.window.document.cookie?.split('; ') ?? <String>[];
    return cookies.map(__cookieFromString).toList();
  }

  Future<void> deleteCookie() async {
    html.window.document.cookie = '';
  }
}
