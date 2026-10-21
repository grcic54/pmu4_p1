import 'package:flutter/material.dart';

import '../models/quake.dart';
import '../services/quake_service.dart';
import '../widgets/magnitude_badge.dart';
import 'detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final Future<List<Quake>> _quakes;

  @override
  void initState() {
    super.initState();
    _quakes = const QuakeService().fetchQuakes();
  }

  Widget _buildDot(Quake quake, Size size) {
    return Positioned(
      left: (quake.longitude + 180) / 360 * size.width - 24, // -180 ... 180
      top: (90 - quake.latitude) / 180 * size.height - 24, // 90 ... -90
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailScreen(quake: quake)),
          ),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: magnitudeColor(quake.magnitude),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Karta')),
      body: FutureBuilder<List<Quake>>(
        future: _quakes,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Potrese nije moguće dohvatiti'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return InteractiveViewer(
            maxScale: 8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 2,
                child: LayoutBuilder(
                  builder: (context, constraints) => Container(
                    color: Colors.blueGrey.shade900,
                    child: Stack(
                      children: [
                        for (final quake in snapshot.data!)
                          _buildDot(quake, constraints.biggest),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
