class RideModel {
  final String id;
  final String name;
  final String genderAge;
  final String date;
  final String from;
  final String to;
  final String type;
  final String model;
  final String color;
  final String plate;
  final int totalSpots;
  final int takenSpots;
  final String observation;
  final String motoristaId;

  RideModel({
    required this.id,
    required this.name,
    required this.genderAge,
    required this.date,
    required this.from,
    required this.to,
    required this.type,
    required this.model,
    required this.color,
    required this.plate,
    required this.totalSpots,
    required this.takenSpots,
    required this.observation,
    required this.motoristaId,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    // Converter id para string, mesmo que venha como int
    final id = json['id']?.toString() ?? '';
    
    return RideModel(
      id: id,
      name: json['name']?.toString() ?? 'Motorista',
      genderAge: json['genderAge']?.toString() ?? 'Não informado',
      date: json['date']?.toString() ?? '',
      from: json['from']?.toString() ?? json['origem']?.toString() ?? '',
      to: json['to']?.toString() ?? json['destino']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Não informado',
      model: json['model']?.toString() ?? 'Não informado',
      color: json['color']?.toString() ?? 'Não informado',
      plate: json['plate']?.toString() ?? 'Não informado',
      totalSpots: (json['totalSpots'] ?? json['vagas'] ?? 0) is int 
          ? (json['totalSpots'] ?? json['vagas'] ?? 0) as int
          : int.tryParse((json['totalSpots'] ?? json['vagas'] ?? '0').toString()) ?? 0,
      takenSpots: (json['takenSpots'] ?? 0) is int
          ? (json['takenSpots'] ?? 0) as int
          : int.tryParse((json['takenSpots'] ?? '0').toString()) ?? 0,
      observation: json['observation']?.toString() ?? json['observacao']?.toString() ?? '',
      motoristaId: json['motoristaId']?.toString() ?? id, // fallback para id se motoristaId não existir
    );
  }
}
