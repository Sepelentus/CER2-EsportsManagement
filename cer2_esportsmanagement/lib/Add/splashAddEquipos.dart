import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarEquipo extends StatefulWidget {
  @override
  _AgregarEquipoState createState() => _AgregarEquipoState();
}

class _AgregarEquipoState extends State<AgregarEquipo> {
  String? nombre;
  String? id;

  Future<void> saveTeamName(String nombre, String id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/equipos/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombre': nombre,
        'id': "0",
      }),
    );

    if (response.statusCode != 200) {
      print('Failed to save team name. Server responded with: ${response.body}');
      throw Exception('Failed to save team name');
    }

    setState(() {});
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
          title: Text('CAMPEONATOS'),
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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  onChanged: (value) {
                    nombre = value;
                    id = "0";
                  },
                  decoration: InputDecoration(
                    labelText: 'Nombre del equipo',
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nombre != null && id != null) {
                    saveTeamName(nombre!, id!);
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}