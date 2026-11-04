import 'package:flutter/material.dart';

import '../models/quake.dart';
import '../services/quake_service.dart';
import '../widgets/quake_tile.dart';
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _service = const QuakeService();
  late Future<List<Quake>> _quakes;
  final _removed = <String>{}; // Set<String>
  final _pinned = <String>{}; // Set<String>

  @override
  void initState() {
    super.initState();
    _quakes = _service.fetchQuakes();
  }

  Future<void> _reload() {
    setState(() {
      _quakes = _service.fetchQuakes();
    });
    return _quakes;
  }

  void _openDetail(Quake quake) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailScreen(quake: quake),
      ),
    );
  }

  void _togglePin(Quake quake) {
    setState(() {
      if (!_pinned.remove(quake.id)) _pinned.add(quake.id);
    });
  }

  void _remove(Quake quake) {
    setState(() {
      _removed.add(quake.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Uklonjeno: ${quake.place}'),
        action: SnackBarAction(
          label: 'Poništi',
          onPressed: () {
            if (!mounted) return;
            setState(() {
              _removed.remove(quake.id);
            });
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Quake> quakes) {
    final visible = quakes.where((q) => !_removed.contains(q.id)).toList();

    if (visible.isEmpty) {
      return const Center(child: Text('Nema potresa za prikaz'));
    }

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: visible.length,
        itemBuilder: (context, index) {
          final quake = visible[index];
          return QuakeTile(
            quake: quake,
            pinned: _pinned.contains(quake.id),
            onTap: () => _openDetail(quake),
            onLongPress: () => _togglePin(quake),
            onDismissed: () => _remove(quake),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Potresi - 24 h')),
      body: FutureBuilder<List<Quake>>(
        future: _quakes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 48),
                  const SizedBox(height: 12),
                  const Text('Provjeri internetsku vezu i pokušaj ponovno'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _reload,
                    child: Text('Pokušaj ponovno'),
                  ),
                ],
              ),
            );
          }
          return _buildList(snapshot.data!);
        },
      ),
    );
  }
}
