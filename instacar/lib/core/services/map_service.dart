import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapService {
  static const String baseUrl = 'http://localhost:3000'; // URL da sua API
  static final Map<String, Map<String, double>> _geoCache = {};
  
  // Dados de exemplo das caronas (você pode substituir por dados reais da API)
  static List<Map<String, dynamic>> _sampleRides = [
    {
      'id': 1,
      'from': 'Centro, Marília',
      'to': 'Rodoviária, Marília',
      'price': '',
      'time': '14:30',
      'seats': 2,
      'lat': -22.215,
      'lng': -49.945,
      'driver': 'João Silva',
      'driverId': 'driver1',
      'isMock': true, // Flag para identificar caronas mockadas
    },
    {
      'id': 2,
      'from': 'Cascata, Marília',
      'to': 'UNIMAR, Marília',
      'price': '',
      'time': '16:45',
      'seats': 1,
      'lat': -22.222,
      'lng': -49.955,
      'driver': 'Maria Santos',
      'driverId': 'driver2',
      'isMock': true,
    },
    {
      'id': 3,
      'from': 'Palmital, Marília',
      'to': 'Centro, Marília',
      'price': '',
      'time': '18:20',
      'seats': 3,
      'lat': -22.210,
      'lng': -49.960,
      'driver': 'Pedro Costa',
      'driverId': 'driver3',
      'isMock': true,
    },
    {
      'id': 4,
      'from': 'Nova Marília, Marília',
      'to': 'Marília Shopping',
      'price': '',
      'time': '19:10',
      'seats': 1,
      'lat': -22.225,
      'lng': -49.940,
      'driver': 'Ana Lima',
      'driverId': 'driver4',
      'isMock': true,
    },
    {
      'id': 5,
      'from': 'Lácio, Marília',
      'to': 'Centro, Marília',
      'price': '',
      'time': '20:15',
      'seats': 2,
      'lat': -22.230,
      'lng': -49.952,
      'driver': 'Carlos Oliveira',
      'driverId': 'driver5',
      'isMock': true,
    }
  ];

  // Buscar caronas disponíveis
  static Future<List<Map<String, dynamic>>> getAvailableRides() async {
    try {
      if (kDebugMode) {
        print('Buscando caronas da API: $baseUrl/api/caronas');
      }
      final response = await http.get(Uri.parse('$baseUrl/api/caronas'));
      
      if (kDebugMode) {
        print('Status da resposta: ${response.statusCode}');
      }
      
      if (response.statusCode == 200) {
        final List<dynamic> list = json.decode(response.body) as List<dynamic>;
        
        if (kDebugMode) {
          print('Caronas recebidas da API: ${list.length}');
        }
        
        // Se a lista estiver vazia, retornar lista vazia (não usar mocks)
        if (list.isEmpty) {
          if (kDebugMode) {
            print('Nenhuma carona encontrada na API');
          }
          return [];
        }
        
        final List<Map<String, dynamic>> output = [];
        for (final item in list) {
          final map = item as Map<String, dynamic>;
          final id = (map['id'] ?? '').toString();
          final origem = (map['origem'] ?? map['from'] ?? '').toString();
          final destino = (map['destino'] ?? map['to'] ?? '').toString();
          final dataHora = (map['dataHora'] ?? map['date'] ?? '').toString();
          final vagas = (map['vagasDisponiveis'] ?? map['vagas'] ?? map['seats'] ?? 0) as int;
          double? lat = _toDouble(map['origem_lat'] ?? map['lat']);
          double? lng = _toDouble(map['origem_lon'] ?? map['lng']);
          double? destLat = _toDouble(map['destino_lat'] ?? map['destLat']);
          double? destLng = _toDouble(map['destino_lon'] ?? map['destLng']);

          if (lat == null || lng == null) {
            if (origem.isNotEmpty) {
              final geo = await _geocodeAddress(origem);
              lat = geo?['lat'];
              lng = geo?['lng'];
            }
          }

          if (destLat == null || destLng == null) {
            if (destino.isNotEmpty) {
              final geoDest = await _geocodeAddress(destino);
              destLat = geoDest?['lat'];
              destLng = geoDest?['lng'];
            }
          }

          if (lat == null || lng == null) {
            // se não conseguiu geocodificar, pula
            if (kDebugMode) {
              print('Pulando carona $id: não foi possível obter coordenadas');
            }
            continue;
          }

          output.add({
            'id': id,
            'from': origem,
            'to': destino,
            'price': map['price'] ?? '', // pode não existir no backend
            'time': dataHora,
            'seats': vagas,
            'lat': lat,
            'lng': lng,
            'destLat': destLat,
            'destLng': destLng,
            'driver': map['motoristaNome'] ?? map['name'] ?? map['driver'] ?? 'Motorista',
            'driverId': map['motoristaId']?.toString() ?? map['driverId']?.toString() ?? '',
            'isMock': false, // Flag para identificar que são caronas reais
          });
        }

        if (kDebugMode) {
          print('Caronas processadas e prontas para exibição: ${output.length}');
        }

        return output;
      } else {
        if (kDebugMode) {
          print('Erro na API: Status ${response.statusCode} - ${response.body}');
        }
        // Se a API retornou erro mas não está inacessível, retornar lista vazia
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar caronas da API: $e');
        print('Tipo do erro: ${e.runtimeType}');
      }
      // Se houver erro de conexão, retornar lista vazia (não usar mocks automaticamente)
      // Os mocks só devem ser usados em caso de necessidade explícita
      return [];
    }
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) {
      return double.tryParse(v);
    }
    return null;
  }

  static Future<Map<String, double>?> _geocodeAddress(String address) async {
    if (address.isEmpty) return null;
    if (_geoCache.containsKey(address)) return _geoCache[address];
    try {
      final uri = Uri.parse('https://nominatim.openstreetmap.org/search').replace(queryParameters: {
        'q': address,
        'format': 'json',
        'limit': '1',
      });
      final resp = await http.get(uri, headers: {
        'User-Agent': 'instacar-app/1.0 (contact: dev@instacar)'
      });
      if (resp.statusCode == 200) {
        final List<dynamic> results = json.decode(resp.body) as List<dynamic>;
        if (results.isNotEmpty) {
          final r = results.first as Map<String, dynamic>;
          final lat = double.tryParse(r['lat']?.toString() ?? '');
          final lon = double.tryParse(r['lon']?.toString() ?? '');
          if (lat != null && lon != null) {
            final out = {'lat': lat, 'lng': lon};
            _geoCache[address] = out;
            return out;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro no geocode "$address": $e');
      }
    }
    return null;
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

  static void centerOnUser() {
    if (kIsWeb) {
      try {
        final iframe = html.document.querySelector('iframe[src="map.html"]') as html.IFrameElement?;
        if (iframe != null && iframe.contentWindow != null) {
          iframe.contentWindow!.postMessage('centerOnUser', '*');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao solicitar centralização no usuário: $e');
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
        // Retorna localização de exemplo em Marília
        return {
          'lat': -22.2171,
          'lng': -49.9501,
        };
      }
    }
    return {
      // Marília - SP fallback
      'lat': -22.2171,
      'lng': -49.9501,
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