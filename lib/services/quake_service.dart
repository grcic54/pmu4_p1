import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quake.dart';

class QuakeService {
  
  const QuakeService();

  static final _feed = Uri.parse(
    'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson'
  );

  Future<List<Quake>> fetchQuakes() async{
    final response = await http.get(_feed).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200){
      throw Exception('USGS je vratio status ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final features = json['features'] as List<dynamic>;

    return features
    .map((feature) => Quake.fromJson(feature as Map<String, dynamic>)).toList();
  }

  Stream<List<Quake>> watchQuakes() async* {
    while(true){
      yield await fetchQuakes();
      await Future.delayed(const Duration(minutes: 1));
    }
  }
}

