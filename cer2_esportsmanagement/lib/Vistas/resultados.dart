import 'package:flutter/material.dart';

class VistaResultados extends StatelessWidget {
  const VistaResultados({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RESULTADOS'),
        titleSpacing: 4,

      ),
      body: Center(
        child: Text('Resultados'),
      ),
    );
  }
}