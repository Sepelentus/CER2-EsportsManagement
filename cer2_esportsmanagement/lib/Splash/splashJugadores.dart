import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JugadoresPage extends StatefulWidget {
  final int equipoId;

  JugadoresPage({required this.equipoId});

  @override
  _JugadoresPageState createState() => _JugadoresPageState();
}

class _JugadoresPageState extends State<JugadoresPage> {
  List<Map<String, dynamic>> jugadores = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var responseJugadores = await http.get(Uri.parse('http://10.0.2.2:8000/jugadores/')); // Reemplaza con la URL de los jugadores
    var responseEquipos = await http.get(Uri.parse('http://10.0.2.2:8000/equipos/')); // Reemplaza con la URL de los equipos

    if (responseJugadores.statusCode == 200 && responseEquipos.statusCode == 200) {
      List<dynamic> jugadoresData = json.decode(responseJugadores.body);
      List<dynamic> equiposData = json.decode(responseEquipos.body);

      setState(() {
        jugadores = jugadoresData.where((jugador) => jugador['equipo_id'] == widget.equipoId).map((jugador) {
          var equipo = equiposData.firstWhere((equipo) => equipo['id'] == jugador['equipo_id'], orElse: () => null);
          return {
            'nombre': jugador['nombre'],
            'equipo_nombre': equipo != null ? equipo['nombre'] : 'Unknown',
            // Añade aquí el resto de los campos que necesites
          };
        }).toList();
      });
    } else {
      print('Error con la petición: ${responseJugadores.statusCode}, ${responseEquipos.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUGADORES'),
      ),
      body: ListView.builder(
        itemCount: jugadores.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(' ${jugadores[index]['nombre']}', style: TextStyle(color: Colors.black)),
          );
        },
      ),
    );
  }
}