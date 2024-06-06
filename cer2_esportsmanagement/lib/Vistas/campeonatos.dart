import 'package:flutter/material.dart';

class VistaCampeonatos extends StatelessWidget {
  const VistaCampeonatos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CAMPEONATOS'),
        titleSpacing: 4,

      ),
      body: Center(
        child: Text('Campeonatos'),
      ),
    );
  }
}