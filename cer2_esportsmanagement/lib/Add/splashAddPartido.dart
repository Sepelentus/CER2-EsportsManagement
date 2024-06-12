import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashAddPartido extends StatefulWidget {
  @override
  _SplashAddPartidoState createState() => _SplashAddPartidoState();
}

class _SplashAddPartidoState extends State<SplashAddPartido> {
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  String fecha = '';
  List<int> equipos_ids = [];
  String lugar = '';
  int campeonato_id = 0;
  final fechaController = TextEditingController();
  // Lista de equipos
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
  Future<void> addPartido(
    String fecha,
    List<int> equipos_ids,
    String lugar,
    int campeonato_id,
    int id,
  ) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/partidos/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': 0,
        'fecha': fecha,
        'equipos_ids': equipos_ids,
        'lugar': lugar,
        'campeonato_id': campeonato_id,
      }),
    );

    if (response.statusCode == 200) {
      print('Partido añadido con éxito.');
    } else {
      throw Exception('Failed to add partido.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEquipos();
  }

  // Hacer widgets correspondientes futuro developer de aqui
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
