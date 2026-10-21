import 'package:flutter/material.dart';

import '../models/quake.dart';
import '../widgets/magnitude_badge.dart';

class DetailScreen extends StatefulWidget {
  final Quake quake;

  const DetailScreen({super.key, required this.quake});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;
  bool _miles = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

    if (widget.quake.magnitude >= 4.5) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quake = widget.quake;
    final depth = _miles
        ? '${(quake.depthKm * 0.621).toStringAsFixed(1)} mi'
        : '${quake.depthKm.toStringAsFixed(1)} km';

    return Scaffold(
      appBar: AppBar(title: Text(quake.place)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: ScaleTransition(
              scale: _scale,
              child: Hero(
                tag: 'magnitude-${quake.id}',
                child: MagnitudeBadge(magnitude: quake.magnitude, size: 140),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: Text('Vrijeme'),
            trailing: Text(quake.timeLabel),
          ),
          ListTile(
            leading: const Icon(Icons.place),
            title: const Text('Koordinate'),
            trailing: Text(
              '${quake.latitude.toStringAsFixed(2)},'
              '${quake.longitude.toStringAsFixed(2)}',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.vertical_align_bottom),
            title: const Text('Dubina'),
            subtitle: const Text('Dodirni za km ili mi'),
            onTap: () => setState(() {
              _miles = !_miles;
            }),
            trailing: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(depth, key: ValueKey(_miles)),
            ),
          ),
        ],
      ),
    );
  }
}