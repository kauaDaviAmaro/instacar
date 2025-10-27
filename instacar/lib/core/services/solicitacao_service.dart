import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SolicitacaoService {
  static const String baseUrl = 'http://localhost:3000/api/solicitacoes-carona';

  // Solicitar uma carona
  static Future<Map<String, dynamic>> solicitarCarona({
    required String caronaId,
    String? mensagem,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'caronaId': caronaId,
          'mensagem': mensagem,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao solicitar carona');
      }
    } catch (e) {
      throw Exception('Erro de rede: $e');
    }
  }

  // Obter minhas solicitações enviadas
  static Future<List<Map<String, dynamic>>> getMinhasSolicitacoes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      final response = await http.get(
        Uri.parse('$baseUrl/minhas'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao buscar solicitações');
      }
    } catch (e) {
      throw Exception('Erro de rede: $e');
    }
  }

  // Obter solicitações recebidas (para motoristas)
  static Future<List<Map<String, dynamic>>> getSolicitacoesRecebidas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      final response = await http.get(
        Uri.parse('$baseUrl/recebidas'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao buscar solicitações recebidas');
      }
    } catch (e) {
      throw Exception('Erro de rede: $e');
    }
  }

  // Responder uma solicitação (aceitar/rejeitar)
  static Future<Map<String, dynamic>> responderSolicitacao({
    required String solicitacaoId,
    required String status, // 'aceita' ou 'rejeitada'
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      final response = await http.put(
        Uri.parse('$baseUrl/$solicitacaoId/responder'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao responder solicitação');
      }
    } catch (e) {
      throw Exception('Erro de rede: $e');
    }
  }

  // Cancelar uma solicitação
  static Future<void> cancelarSolicitacao(String solicitacaoId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      final response = await http.put(
        Uri.parse('$baseUrl/$solicitacaoId/cancelar'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Erro ao cancelar solicitação');
      }
    } catch (e) {
      throw Exception('Erro de rede: $e');
    }
  }

  // Verificar se o usuário já solicitou uma carona específica
  static Future<bool> jaSolicitouCarona(String caronaId) async {
    try {
      final solicitacoes = await getMinhasSolicitacoes();
      return solicitacoes.any((solicitacao) => 
        solicitacao['carona']['id'] == caronaId && 
        solicitacao['status'] == 'pendente'
      );
    } catch (e) {
      return false;
    }
  }

  // Obter status da solicitação para uma carona específica
  static Future<String?> getStatusSolicitacao(String caronaId) async {
    try {
      final solicitacoes = await getMinhasSolicitacoes();
      final solicitacao = solicitacoes.where(
        (solicitacao) => solicitacao['carona']['id'] == caronaId,
      ).firstOrNull;
      return solicitacao?['status'];
    } catch (e) {
      return null;
    }
  }
}
