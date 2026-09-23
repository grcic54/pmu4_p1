import 'dart:js_interop';

class Quake {
  final String id;
  final String place;
  final double magnitude;
  final double depthKm;
  final double latitude;
  final double longitude;
  final DateTime time;

  const Quake ({
    required this.id,
    required this.place,
    required this.magnitude,
    required this.depthKm,
    required this.latitude,
    required this.longitude,
    required this.time
  });

  String get timeLabel {
    final minute = time.minute.toString().padLeft(2, '0');
    return '${time.day}. ${time.month}. u ${time.hour}:$minute';
  }

  factory Quake.fromJson(Map<String, dynamic> json) { //tvornica metoda na json mapa stringova dinamckih vrijednosti
  

  }
}