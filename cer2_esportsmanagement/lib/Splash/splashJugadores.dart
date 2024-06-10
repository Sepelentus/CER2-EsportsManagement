import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JugadoresPage extends StatefulWidget {
  final String equipoId;

  JugadoresPage({required this.equipoId});

  @override
  _JugadoresPageState createState() => _JugadoresPageState();
}

class _JugadoresPageState extends State<JugadoresPage> {
  List<dynamic> jugadores = [];

  @override
  void initState() {
    super.initState();
    fetchJugadores();
  }
Future<void> fetchJugadores() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/jugadores/?equipoId=${widget.equipoId}'));
  if (response.statusCode == 200) {
    var allJugadores = jsonDecode(response.body);
    setState(() {
      jugadores = allJugadores;
    });
  } else {
    throw Exception('Failed to load jugadores');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUGADORES'),
        // Resto de tu código...
      ),
      body: ListView.builder(
        itemCount: jugadores.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(jugadores[index]['nombre'], style: TextStyle(color: Colors.black)),
            // Aquí puedes añadir más detalles sobre cada jugador
          );
        },
      ),
    );
  }
}