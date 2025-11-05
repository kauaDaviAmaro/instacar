import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:instacar/core/models/RideModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RideService {
  static const String baseUrl = 'http://localhost:3000/api/caronas';

  Future<List<RideModel>> fetchRides() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print('Rides fetched: ${jsonData.length}');
      return jsonData.map((item) => RideModel.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar caronas');
    }
  }

  Future<RideModel> fetchRideById(String id) async {
    try {
      print('Buscando carona com ID: $id');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final url = '$baseUrl/$id';
      print('URL da requisição: $url');
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonData = json.decode(response.body);
          return RideModel.fromJson(jsonData);
        } catch (e) {
          print('Erro ao fazer parse do JSON: $e');
          print('Resposta da API: ${response.body}');
          throw Exception('Erro ao processar dados da carona: $e');
        }
      } else if (response.statusCode == 404) {
        print('Carona não encontrada: ID $id');
        print('Resposta da API: ${response.body}');
        throw Exception('Carona não encontrada. O ID pode não existir no banco de dados.');
      } else if (response.statusCode == 401) {
        throw Exception('Não autorizado. Faça login novamente.');
      } else {
        print('Erro HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Erro ao carregar detalhes da carona (${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      print('Erro ao buscar carona: $e');
      throw Exception('Erro de conexão: $e');
    }
  }
}
