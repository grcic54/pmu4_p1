import 'package:flutter/material.dart';
import '../models/quake.dart';
import '../services/quake_service.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {

  late final Stream<List<Quake>> _quakes;
  int _sortColumn = 0;
  bool _ascending = false;

  @override
  void initState() {
    super.initState();
    _quakes = const QuakeService().watchQuakes();
  
  }

void _sort(int column, bool ascending) {
    setState(() {
      _sortColumn = column;
      _ascending = ascending;
    });
  }

  int _compare(Quake a, Quake b) {
    final result = switch (_sortColumn) {
      0 => a.magnitude.compareTo(b.magnitude),
      1 => a.depthKm.compareTo(b.depthKm),
      _ => a.time.compareTo(b.time),
    };
    return _ascending ? result : -result;
  }

  Widget _buildTable(List<Quake> quakes) {
    final strongest = [...quakes]
      ..sort((a, b) => b.magnitude.compareTo(a.magnitude));
      final rows = strongest.take(10).toList()..sort(_compare);

    return Placeholder();
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}