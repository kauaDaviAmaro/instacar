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
    return RideModel(
      id: json['id'], // ou 'id' se for o nome correto
      name: json['name'],
      genderAge: json['genderAge'],
      date: json['date'],
      from: json['from'],
      to: json['to'],
      type: json['type'],
      model: json['model'],
      color: json['color'],
      plate: json['plate'],
      totalSpots: json['totalSpots'],
      takenSpots: json['takenSpots'],
      observation: json['observation'],
      motoristaId: json['motoristaId'] ?? json['id'], // fallback para id se motoristaId não existir
    );
  }
}
