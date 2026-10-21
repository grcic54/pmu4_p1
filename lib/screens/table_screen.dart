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
      _ => a.time.compareTo(b.time)
    };
    return _ascending ? result : -result;
  }

  Widget _buildTable(List<Quake> quakes) {
    final strongest = [...quakes]
    ..sort((a, b) => b.magnitude.compareTo(a.magnitude));
    final rows = strongest.take(10).toList()..sort(_compare);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: _sortColumn,
        sortAscending: _ascending,
        columns: [
          DataColumn(label: const Text('Mag.'), numeric: true, onSort: _sort),
          DataColumn(label: const Text('Dubina (km.)'), numeric: true, onSort: _sort),
          DataColumn(label: const Text('Vrijeme'), onSort: _sort),
          const DataColumn(label: const Text('Mjesto'))
        ],
        rows: [
          for (final quake in rows)
          DataRow(cells: [
            DataCell(Text(quake.magnitude.toStringAsFixed(1))),
            DataCell(Text(quake.depthKm.toStringAsFixed(1))),
            DataCell(Text(quake.timeLabel.toString())),
            DataCell(Text(quake.place))
          ])
        ]
        ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10 najjačih - uživo')),
      body: StreamBuilder<List<Quake>>(
        stream: _quakes,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Potrese nije moguće dohvatiti'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildTable(snapshot.data!);
        },
      ),
    );
  }
}