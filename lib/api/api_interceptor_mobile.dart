import 'package:almeidatec/main.dart';
import 'package:almeidatec/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Cookie {
  final String name, value;

  Cookie(this.name, this.value);
}

class CookieInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? __activeCookies;
  final String __sep = '; ';
  final String __key = 'cookies';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.extra['withCredentials'] = true;
    __activeCookies ??= await _storage.read(key: __key);
    if (__activeCookies != null && __activeCookies!.isNotEmpty) {
      options.headers['cookie'] = __activeCookies;
    }
    List<Cookie> cookies = await getCookies();
    for (Cookie cookie in cookies) {
      if (cookie.name == 'token') {
        currentCookie = cookie.value;
        break;
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) async {
    try {
      await _saveCookies(response);
      handler.next(response);
    } catch (e, stack) {
      DioException err = DioException(
        requestOptions: response.requestOptions,
        error: e,
        stackTrace: stack,
      );
      handler.reject(err, true);
    }
  }

  String? currentCookie;

  @override
  void onError( DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null) {
      Response<dynamic> response = err.response!;
      try {
        if (response.statusCode == 403) {
          await deleteCookie();
          MyApp.appStateKey.currentState?.pushNamed(Routes.login);
        } else {
          await _saveCookies(response);
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

  Future<void> _saveCookies(Response<dynamic> response) async {
    List<String> cookies = <String>[];
    for (String key in <String>['set-cookie', 'Set-Cookie']) {
      cookies.addAll(response.headers[key] ?? <String>[]);
    }
    if (cookies.isEmpty) {
      return;
    }
    __activeCookies = cookies.join(__sep);
    await _storage.write(key: __key, value: cookies.join(__sep));
  }

  Future<List<Cookie>> getCookies() async {
    __activeCookies ??= await _storage.read(key: __key);
    return __activeCookies?.split(__sep).map(__cookieFromString).toList() ??
        <Cookie>[];
  }

  Future<void> deleteCookie() async {
    await _storage.delete(key: __key);
    __activeCookies = "";
  }
}
