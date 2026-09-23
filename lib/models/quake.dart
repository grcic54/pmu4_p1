class Quake {
  final String id;
  final String place;
  final double magnitude;
  final double depthKm;
  final double latitude;
  final double longitude;
  final DateTime time;

  const Quake({
    required this.id,
    required this.place,
    required this.magnitude,
    required this.depthKm,
    required this.latitude,
    required this.longitude,
    required this.time,
  });

  String get timeLabel {
    final minute = time.minute.toString().padLeft(2, '0');
    return '${time.day}. ${time.month}. u ${time.hour}:$minute';
  }

  factory Quake.fromJson(Map<String, dynamic> json) {
    //tvornica metoda na json mapa stringova dinamckih vrijednosti
    final properties = json['properties'] as Map<String, dynamic>;
    final coordinates = json['geometry']['coordinates'] as List<dynamic>;

    return Quake(
      id: json['id'] as String,
      place: properties['place'] as String? ?? 'Nepoznato',
      magnitude: (properties['mag'] as num).toDouble(),
      depthKm: (coordinates[2] as num).toDouble(),
      latitude: (coordinates[1] as num).toDouble(),
      longitude: (coordinates[0] as num).toDouble(),
      time: DateTime.fromMillisecondsSinceEpoch(properties['time'] as int),
    );
  }
}
