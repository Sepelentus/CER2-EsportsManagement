import 'package:flutter/material.dart';

class VistaCalendarios extends StatelessWidget {
  const VistaCalendarios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CALENDARIOS'),
        titleTextStyle: TextStyle(
          fontFamily: 'Outfit',
        ),

      ),
      body: Center(
        child: Text('Calendarios'),
      ),
    );
  }
}