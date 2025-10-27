import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
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

  // Get or create conversation between two users
  static Future<Map<String, dynamic>> getOrCreateConversation(String user2Id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/conversation'),
        headers: headers,
        body: jsonEncode({'user2Id': user2Id}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create conversation: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating conversation: $e');
      rethrow;
    }
  }

  // Send a message
  static Future<Map<String, dynamic>> sendMessage(String receiverId, String message) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/message'),
        headers: headers,
        body: jsonEncode({
          'receiverId': receiverId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  // Get user's conversations
  static Future<List<dynamic>> getUserConversations() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/chat/conversations'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch conversations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching conversations: $e');
      rethrow;
    }
  }

  // Get messages from a conversation
  static Future<List<dynamic>> getConversationMessages(String conversationId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/chat/conversation/$conversationId/messages'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch messages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching messages: $e');
      rethrow;
    }
  }
}