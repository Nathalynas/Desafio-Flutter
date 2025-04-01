import 'package:dio/dio.dart';

typedef JSON = Map<String, dynamic>;

class HTTPError {
  final int statusCode;
  final String? message;
  final Map<String, dynamic>? data;
  HTTPError(this.statusCode, {this.message, this.data});
  @override
  String toString() {
    return message ?? super.toString();
  }
}

Future<T> requestWrapper<T>(Function request) async {
  try {
    return await request();
  } catch (e) {
    if (e is DioException) {
      throw HTTPError(
        e.response?.statusCode ?? 500,
        message: "${e.message}: ${e.response?.data}",
        data: (e.response?.data is Map<String, dynamic>)
            ? e.response?.data
            : null,
      );
    }
    throw HTTPError(500, message: "Unexpected app error");
  }
}
