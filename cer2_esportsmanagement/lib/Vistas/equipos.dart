import 'package:flutter/material.dart';

class VistaEquipos extends StatelessWidget {
  const VistaEquipos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EQUIPOS'),
        titleSpacing: 4,

      ),
      body: const Center(
        child: Text('Equipos'),
      ),
    );
  }
}