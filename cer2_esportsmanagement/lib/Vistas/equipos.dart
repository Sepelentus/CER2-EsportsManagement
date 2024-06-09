import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class getTeamsScreen extends StatefulWidget {

  @override
  State<getTeamsScreen> createState() => _getTeamsScreenState();
}

class Equipo {
  final int id;
  final String nombre;

  Equipo({required this.id, required this.nombre});

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}

// Get and List stuff from equipos
Future<List<Equipo>> fetchEquipos() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/equipos/'));
  if (response.statusCode == 200) {
    List<dynamic> equiposJson = jsonDecode(response.body);
    return equiposJson.map((json) => Equipo.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load equipos');
  }
}

  class _getTeamsScreenState extends State<getTeamsScreen>{

  @override
  void initState(){
    super.initState();
    fetchEquipos();
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder<List<Equipo>>(
      future: fetchEquipos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Equipo equipo = snapshot.data![index];
              return Card(
                elevation: 5,
          color: const Color.fromARGB(255,229,203,93),
          child: ListTile(
            title: Text(equipo.nombre, style: TextStyle(fontSize: 20, 
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255,48,25,95))),
            subtitle: Text('Jugadores: %%'),
            leading: Icon(Icons.sports_esports, size: 35, color: const Color.fromARGB(255,48,25,95),),
            trailing: IconButton(
              icon : Icon(Icons.arrow_forward_ios),
              onPressed: () {
                //Accion (Splash a info de jugadores)
              },),
            tileColor: const Color.fromARGB(255,229,203,93),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
                // Build your card for 'equipo' here.
                // You can access the team's name with 'equipo.nombre'
                // and the players' names with 'equipo.jugadores'.
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

}