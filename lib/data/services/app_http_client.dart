import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:mytask/utils/app_constants.dart';

class AppHttpClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.BASE_URL));

  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      developer.log('GET Request URL: ${_dio.options.baseUrl}$endpoint${params != null ? '?${Uri(queryParameters: params).query}' : ''}', name: 'AppHttpClient');
      developer.log('GET Request Headers: ${_dio.options.headers}', name: 'AppHttpClient');

      final response = await _dio.get(endpoint, queryParameters: params);

      developer.log('GET Response: ${response.statusCode} - ${response.data}', name: 'AppHttpClient');

      return response;
    } catch (e) {
      developer.log('GET Error: $e', name: 'AppHttpClient');
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Response> post(String endpoint, {required Map<String, dynamic> body}) async {
    try {
      developer.log('POST Request URL: ${_dio.options.baseUrl}$endpoint', name: 'AppHttpClient');
      developer.log('POST Request Body: $body', name: 'AppHttpClient');
      developer.log('POST Request Headers: ${_dio.options.headers}', name: 'AppHttpClient');

      final response = await _dio.post(endpoint, data: body);

      developer.log('POST Response: ${response.statusCode} - ${response.data}', name: 'AppHttpClient');

      return response;
    } catch (e) {
      developer.log('POST Error: $e', name: 'AppHttpClient');
      throw Exception('Failed to post data: $e');
    }
  }

  Future<Response> put(String endpoint, {required Map<String, dynamic> body}) async {
    try {
      developer.log('PUT Request URL: ${_dio.options.baseUrl}$endpoint', name: 'AppHttpClient');
      developer.log('PUT Request Body: $body', name: 'AppHttpClient');
      developer.log('PUT Request Headers: ${_dio.options.headers}', name: 'AppHttpClient');

      final response = await _dio.put(endpoint, data: body);

      developer.log('PUT Response: ${response.statusCode} - ${response.data}', name: 'AppHttpClient');

      return response;
    } catch (e) {
      developer.log('PUT Error: $e', name: 'AppHttpClient');
      throw Exception('Failed to update data (PUT): $e');
    }
  }

  Future<Response> patch(String endpoint, {required Map<String, dynamic> body}) async {
    try {
      developer.log('PATCH Request URL: ${_dio.options.baseUrl}$endpoint', name: 'AppHttpClient');
      developer.log('PATCH Request Body: $body', name: 'AppHttpClient');
      developer.log('PATCH Request Headers: ${_dio.options.headers}', name: 'AppHttpClient');

      final response = await _dio.patch(endpoint, data: body);

      developer.log('PATCH Response: ${response.statusCode} - ${response.data}', name: 'AppHttpClient');

      return response;
    } catch (e) {
      developer.log('PATCH Error: $e', name: 'AppHttpClient');
      throw Exception('Failed to update data (PATCH): $e');
    }
  }

  Future<Response> delete(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      developer.log('DELETE Request URL: ${_dio.options.baseUrl}$endpoint${params != null ? '?${Uri(queryParameters: params).query}' : ''}', name: 'AppHttpClient');
      developer.log('DELETE Request Headers: ${_dio.options.headers}', name: 'AppHttpClient');

      final response = await _dio.delete(endpoint, queryParameters: params);

      developer.log('DELETE Response: ${response.statusCode} - ${response.data}', name: 'AppHttpClient');

      return response;
    } catch (e) {
      developer.log('DELETE Error: $e', name: 'AppHttpClient');
      throw Exception('Failed to delete data: $e');
    }
  }
}