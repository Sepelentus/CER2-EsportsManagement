import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Splashadddcampeonato extends StatefulWidget {
  @override
  _SplashadddcampeonatoState createState() => _SplashadddcampeonatoState();
}

class _SplashadddcampeonatoState extends State<Splashadddcampeonato> {
  final _formKey = GlobalKey<FormState>();
  String fecha = '';
  String juego = '';
  String id = '';
  List<String> lista_reglas = [];
  List<String> premios = [];
  final fechaController = TextEditingController();
Future<void> addCampeonato(String fecha, String juego, List<String> lista_reglas, List<String> premios, String id) async {

  final response = await http.post(
    Uri.parse('http://10.0.2.2:8000/campeonatos/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id': '0',
      'fecha': fecha,
      'juego': juego,
      'lista_reglas': lista_reglas,
      'premios': premios,
    }),
  );

  if (response.statusCode == 200) {
    print('Campeonato añadido con éxito.');
  } else {
    throw Exception('Failed to add campeonato.');
  }
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
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: fechaController,
                  decoration: InputDecoration(labelText: 'Fecha'),
                  onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      final DateTime finalDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      fecha = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(finalDateTime.toUtc());
                      fechaController.text = fecha;
                    }
                  }
                },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Juego'),
                  onChanged: (value) {
                    juego = value;
                    id = "0";
                  },
                ),
                TextFormField(
            decoration: InputDecoration(labelText: 'Lista de reglas (separadas por comas)'),
            onChanged: (value) {
              lista_reglas = value.split(',');
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Premios (separados por comas)'),
            onChanged: (value) {
              premios = value.split(',');
            },
          ),
                ElevatedButton(
                  onPressed: () async {
                      await addCampeonato(fecha, juego, lista_reglas, premios, id);
                      setState(() {
                      });
                  },
                  child: Text('Añadir Campeonato'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}