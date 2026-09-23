import 'package:flutter/material.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tablica'),),
      body: const Center(child: Text('Ovdje će biti tablica potresa'),),
    );
  }
}
