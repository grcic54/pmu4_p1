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

  void _remove(Quake quake){
    setState(() {
      _removed.add(quake.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Uklonjeno: ${quake.place}'),
        action: SnackBarAction(
          label: 'Poništi' ,
          onPressed: (){
            if (!mounted) return;
            setState(() {
              _removed.remove(quake.id);
            });
          }), 
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
