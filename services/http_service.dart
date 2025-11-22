import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  // ✅ URL untuk Chrome/Web
  static const String baseUrl = 'http://localhost/SHOPPING-APP/php-backend';

  static Future<Map<String, String>> get headers async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  static Future<dynamic> get(String endpoint) async {
    try {
      print('🌐 GET Request: $baseUrl/$endpoint');

      final response = await http
          .get(
            Uri.parse('$baseUrl/$endpoint'),
            headers: await headers,
          )
          .timeout(const Duration(seconds: 10));

      print('📡 GET Response Status: ${response.statusCode}');
      print('📡 GET Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ GET Error: $e');
      throw 'Network error: $e';
    }
  }

  static Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      print('🌐 POST Request: $baseUrl/$endpoint');
      print('🌐 POST Data: $data');

      final response = await http
          .post(
            Uri.parse('$baseUrl/$endpoint'),
            headers: await headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));

      print('📡 POST Response Status: ${response.statusCode}');
      print('📡 POST Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ POST Error: $e');
      throw 'Network error: $e';
    }
  }

  static Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      print('🌐 PUT Request: $baseUrl/$endpoint');
      print('🌐 PUT Data: $data');

      final response = await http
          .put(
            Uri.parse('$baseUrl/$endpoint'),
            headers: await headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));

      print('📡 PUT Response Status: ${response.statusCode}');
      print('📡 PUT Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ PUT Error: $e');
      throw 'Network error: $e';
    }
  }

  static Future<dynamic> delete(String endpoint, dynamic data) async {
    try {
      print('🌐 DELETE Request: $baseUrl/$endpoint');
      print('🌐 DELETE Data: $data');

      final response = await http
          .delete(
            Uri.parse('$baseUrl/$endpoint'),
            headers: await headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));

      print('📡 DELETE Response Status: ${response.statusCode}');
      print('📡 DELETE Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('❌ DELETE Error: $e');
      throw 'Network error: $e';
    }
  }

  static dynamic _handleResponse(http.Response response) {
    print('🔧 Handling response with status: ${response.statusCode}');

    // ✅ HANDLE EMPTY RESPONSE
    if (response.body.isEmpty) {
      print('⚠️ Empty response body');
      return {};
    }

    try {
      final decodedResponse = json.decode(response.body);
      print('✅ Response decoded successfully: $decodedResponse');

      switch (response.statusCode) {
        case 200:
        case 201:
          return decodedResponse;
        case 400:
          throw 'Bad request: ${decodedResponse['message'] ?? 'Unknown error'}';
        case 404:
          throw 'Resource not found: ${decodedResponse['message'] ?? 'Unknown error'}';
        case 500:
          throw 'Server error: ${decodedResponse['message'] ?? 'Unknown error'}';
        default:
          throw 'Request failed with status: ${response.statusCode}';
      }
    } catch (e) {
      print('❌ JSON Decode Error: $e');
      print('🔧 Raw response body: ${response.body}');
      throw 'Invalid JSON response: $e';
    }
  }

  // ✅ TEST CONNECTION METHOD
  static Future<bool> testConnection() async {
    try {
      print('🔍 Testing connection to: $baseUrl/api.php?test=1');
      final response = await get('api.php?test=1');
      print('✅ Connection test successful: $response');
      return true;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }
}
