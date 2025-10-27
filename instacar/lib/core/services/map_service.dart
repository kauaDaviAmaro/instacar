import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import 'dart:html' as html;

class MapService {
  static const String baseUrl = 'http://localhost:3000'; // URL da sua API
  
  // Dados de exemplo das caronas (você pode substituir por dados reais da API)
  static List<Map<String, dynamic>> _sampleRides = [
    {
      'id': 1,
      'from': 'Centro, São Paulo',
      'to': 'Aeroporto de Guarulhos',
      'price': 'R\$ 25,00',
      'time': '14:30',
      'seats': 2,
      'lat': -23.5505,
      'lng': -46.6333,
      'driver': 'João Silva',
      'driverId': 'driver1'
    },
    {
      'id': 2,
      'from': 'Vila Madalena, São Paulo',
      'to': 'Shopping Iguatemi',
      'price': 'R\$ 18,00',
      'time': '16:45',
      'seats': 1,
      'lat': -23.5489,
      'lng': -46.6938,
      'driver': 'Maria Santos',
      'driverId': 'driver2'
    },
    {
      'id': 3,
      'from': 'Pinheiros, São Paulo',
      'to': 'Terminal Tietê',
      'price': 'R\$ 22,00',
      'time': '18:20',
      'seats': 3,
      'lat': -23.5679,
      'lng': -46.6882,
      'driver': 'Pedro Costa',
      'driverId': 'driver3'
    },
    {
      'id': 4,
      'from': 'Moema, São Paulo',
      'to': 'Aeroporto de Congonhas',
      'price': 'R\$ 15,00',
      'time': '19:10',
      'seats': 1,
      'lat': -23.6045,
      'lng': -46.6568,
      'driver': 'Ana Lima',
      'driverId': 'driver4'
    },
    {
      'id': 5,
      'from': 'Itaim Bibi, São Paulo',
      'to': 'Estação da Luz',
      'price': 'R\$ 20,00',
      'time': '20:15',
      'seats': 2,
      'lat': -23.5845,
      'lng': -46.6748,
      'driver': 'Carlos Oliveira',
      'driverId': 'driver5'
    }
  ];

  // Buscar caronas disponíveis
  static Future<List<Map<String, dynamic>>> getAvailableRides() async {
    try {
      // Em produção, você faria uma chamada real para a API
      // final response = await http.get(Uri.parse('$baseUrl/api/rides'));
      // if (response.statusCode == 200) {
      //   return List<Map<String, dynamic>>.from(json.decode(response.body));
      // }
      
      // Por enquanto, retornamos dados de exemplo
      await Future.delayed(const Duration(milliseconds: 500)); // Simular delay da API
      return List.from(_sampleRides);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar caronas: $e');
      }
      return [];
    }
  }

  // Buscar caronas por localização
  static Future<List<Map<String, dynamic>>> getRidesByLocation({
    required double lat,
    required double lng,
    double radiusKm = 10.0,
  }) async {
    try {
      final allRides = await getAvailableRides();
      
      // Filtrar caronas por raio (simulação simples)
      return allRides.where((ride) {
        final distance = _calculateDistance(
          lat, lng, 
          ride['lat'] as double, 
          ride['lng'] as double
        );
        return distance <= radiusKm;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar caronas por localização: $e');
      }
      return [];
    }
  }

  // Calcular distância entre duas coordenadas (fórmula de Haversine)
  static double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // Raio da Terra em km
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLng = _degreesToRadians(lng2 - lng1);
    
    final double a = 
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) * 
        math.sin(dLng / 2) * math.sin(dLng / 2);
    
    final double c = 2 * math.asin(math.sqrt(a));
    
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  // Métodos simplificados para comunicação com o mapa
  static void sendRidesToMap(List<Map<String, dynamic>> rides) {
    if (kIsWeb) {
      try {
        final iframe = html.document.querySelector('iframe[src="map.html"]') as html.IFrameElement?;
        if (iframe != null && iframe.contentWindow != null) {
          iframe.contentWindow!.postMessage({
            'type': 'updateRides',
            'rides': rides
          }, '*');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao enviar dados para o mapa: $e');
        }
      }
    }
  }

  static void centerMapOnLocation(double lat, double lng) {
    if (kIsWeb) {
      try {
        final iframe = html.document.querySelector('iframe[src="map.html"]') as html.IFrameElement?;
        if (iframe != null && iframe.contentWindow != null) {
          iframe.contentWindow!.postMessage({
            'type': 'centerMap',
            'lat': lat,
            'lng': lng
          }, '*');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao centralizar mapa: $e');
        }
      }
    }
  }

  static Future<Map<String, double>?> getCurrentLocation() async {
    if (kIsWeb) {
      try {
        final position = await html.window.navigator.geolocation.getCurrentPosition();
        return {
          'lat': position.coords!.latitude!.toDouble(),
          'lng': position.coords!.longitude!.toDouble(),
        };
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao obter localização: $e');
        }
        // Retorna localização de exemplo em São Paulo
        return {
          'lat': -23.5505,
          'lng': -46.6333,
        };
      }
    }
    return {
      'lat': -23.5505,
      'lng': -46.6333,
    };
  }

  static void addRideToMap(Map<String, dynamic> ride) {
    if (kIsWeb) {
      try {
        final iframe = html.document.querySelector('iframe[src="map.html"]') as html.IFrameElement?;
        if (iframe != null && iframe.contentWindow != null) {
          iframe.contentWindow!.postMessage({
            'type': 'addRide',
            'ride': ride
          }, '*');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao adicionar carona ao mapa: $e');
        }
      }
    }
  }

  static void removeRideFromMap(String rideId) {
    if (kIsWeb) {
      try {
        final iframe = html.document.querySelector('iframe[src="map.html"]') as html.IFrameElement?;
        if (iframe != null && iframe.contentWindow != null) {
          iframe.contentWindow!.postMessage({
            'type': 'removeRide',
            'rideId': rideId
          }, '*');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao remover carona do mapa: $e');
        }
      }
    }
  }
}