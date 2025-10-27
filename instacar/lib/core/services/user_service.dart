import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _baseUrl = 'http://localhost:3000/api';

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Get user by ID
  static Future<Map<String, dynamic>> getUserById(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/users/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;
    }
  }

  // Get current user profile
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final headers = await _getHeaders();
      print('Fazendo requisição para: $_baseUrl/users/profile');
      print('Headers: $headers');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/users/profile'),
        headers: headers,
      );

      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Dados decodificados: $data');
        return data;
      } else {
        throw Exception('Failed to fetch current user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching current user: $e');
      rethrow;
    }
  }

  // Get current user ID
  static Future<String?> getCurrentUserId() async {
    try {
      print('Tentando obter dados do usuário atual...');
      final token = await _getToken();
      print('Token encontrado: ${token != null ? "Sim" : "Não"}');
      
      if (token == null) {
        print('Token não encontrado - usuário não autenticado');
        return null;
      }
      
      final user = await getCurrentUser();
      print('Dados do usuário obtidos: $user');
      
      // A API retorna o usuário diretamente, não dentro de um objeto 'user'
      final userId = user['id']?.toString();
      print('ID do usuário extraído: $userId');
      
      return userId;
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }
}
