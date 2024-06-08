import 'package:flutter/material.dart';

class VistaCalendarios extends StatelessWidget {
  const VistaCalendarios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/appba.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppBar(
              title: Text('EQUIPOS'),
              titleTextStyle: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                letterSpacing: 4,
              ),
              
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wall.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text('Calendarios'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}