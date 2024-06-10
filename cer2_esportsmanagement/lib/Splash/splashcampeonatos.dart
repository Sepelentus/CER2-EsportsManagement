import 'package:cer2_esportsmanagement/Vistas/equipos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Campeonato {
  final int id;
  final String fecha;
  final String juego;
  final List<String> lista_reglas;
  final List<String> premios;

  Campeonato({
    required this.id,
    required this.fecha,
    required this.juego,
    required this.lista_reglas,
    required this.premios,
  });

  factory Campeonato.fromJson(Map<String, dynamic> json) {
    return Campeonato(
      id: json['id'],
      fecha: json['fecha'],
      juego: json['juego'],
      lista_reglas: List<String>.from(json['lista_reglas'].map((x) => x)),
      premios: List<String>.from(json['premios'].map((x) => x)),
    );
  }
}

Future<List<Campeonato>> fetchCampeonatos() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/campeonatos/'));
  if (response.statusCode == 200) {
    List<dynamic> campeonatosJson = jsonDecode(response.body);
    return campeonatosJson.map((json) => Campeonato.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load campeonatos');
  }
}

class SplashCampeonatos extends StatelessWidget {
  const SplashCampeonatos({Key? key}) : super(key: key);

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
    children : [ 
      Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wall.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
      FutureBuilder<List<Campeonato>>(
      future: fetchCampeonatos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  margin: EdgeInsets.all(5),
  elevation: 10,
  child: Column(
    children: <Widget>[
      ListTile(
        title: Text(snapshot.data![index].juego, style: TextStyle(fontFamily: 'Outfit', fontSize: 22, letterSpacing: 4)),
        subtitle: Text('Fecha: ${snapshot.data![index].fecha}\nReglas: ${snapshot.data![index].lista_reglas.join(', ')}\nPremios: ${snapshot.data![index].premios.join(', ')}'),
      ),
      ButtonBar(
        children: <Widget>[
          ElevatedButton(
            child: Text('Ver Equipos'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VistaEquipos()),
              );
            },
          ),
        ],
      ),
    ],
  ),
);
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    ),
    ],
  ),
    );
  }
}