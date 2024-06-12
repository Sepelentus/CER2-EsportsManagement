import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashAddJugador extends StatefulWidget {
  @override
  _SplashAddJugadorState createState() => _SplashAddJugadorState();
}

class _SplashAddJugadorState extends State<SplashAddJugador> {
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  String nombre = '';
  String juego = '';
  int edad = 0;
  String caracteristicas = '';
  // Lista para los nombres de equipos
  List<dynamic> equipos = [];
  int selectedEquipoId = 1;

  // Getter para obtener los nombres de equipo
  Future<void> fetchEquipos() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/equipos/'));
    if (response.statusCode == 200) {
      equipos = jsonDecode(response.body);
      print(equipos);
    } else {
      throw Exception('Failed to fetch equipos.');
    }
  }

  // Post para los jugadores
  Future<void> addJugador(String nombre, String juego, int edad,
      String caracteristicas, int id, int equipo_id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/jugadores/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': 0,
        'nombre': nombre,
        'juego': juego,
        'edad': edad,
        'caracteristicas': caracteristicas,
        'equipo_id': selectedEquipoId,
      }),
    );

    if (response.statusCode == 200) {
      print('Jugador añadido con éxito.');
    } else {
      throw Exception('Failed to add jugador.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEquipos();
  }

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
                title: Text('JUGADORES'),
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
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('assets/images/wall.jpeg'),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nombre Jugador', fillColor: Colors.white),
                  onChanged: (value) {
                    nombre = value;
                    id = 0;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Juego jugador'),
                  onChanged: (value) {
                    juego = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Edad Jugador'),
                  onChanged: (value) {
                    int? edad = int.tryParse(value);
                    if (edad == null) {
                      throw FormatException(
                          'El valor que has ingresado no es valido');
                    }
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Caracteristicas del Jugador'),
                  maxLength: 100,
                  onChanged: (value) {
                    caracteristicas = value;
                  },
                ),
                Column(
                  children: equipos.map((equipo) {
                    return RadioListTile<int>(
                      title: Text(equipo['nombre']),
                      value: equipo['id'],
                      groupValue: selectedEquipoId,
                      onChanged: (int? value) {
                        setState(() {
                          selectedEquipoId = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await addJugador(nombre, juego, edad, caracteristicas, id,
                        selectedEquipoId);
                    setState(() {});
                  },
                  child: Text('Añadir Campeonato'),
                ),
              ],
            ),
          )
        ]));
  }
}
