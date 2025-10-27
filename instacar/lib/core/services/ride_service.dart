import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:instacar/core/models/RideModel.dart';

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
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return RideModel.fromJson(jsonData);
    } else {
      throw Exception('Falha ao carregar detalhes da carona');
    }
  }
}
