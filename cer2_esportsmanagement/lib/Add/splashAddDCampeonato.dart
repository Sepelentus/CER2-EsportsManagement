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
  final juegoController = TextEditingController();
  final lista_reglasControler = TextEditingController();
  final premiosController = TextEditingController();

Future<void> addCampeonato(String fecha, String juego, List<String> lista_reglas, List<String> premios, String id) async {
  if (_formKey.currentState!.validate()) {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/campeonatos/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': '0',
        'fecha': fechaController.text,
        'juego': juegoController.text,
        'lista_reglas': lista_reglasControler.text,
        'premios': premiosController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Campeonato añadido con éxito.');
    } else {
      throw Exception('Failed to add campeonato.');
    }
  } else {
    print('Por favor, completa todos los campos correctamente.');
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(color: const Color.fromARGB(255,48,25,95)),
                    controller: fechaController,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: Color.fromARGB(255, 240, 3, 3),
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[700]),
                hintText: "Fecha",
                prefixIcon: Icon(Icons.calendar_today, color: Color.fromARGB(255, 255,255,255)),
                fillColor: const Color.fromARGB(255,229,203,93)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce una fecha.';
                      }
                      if (value.length < 19) {
                        return 'Por favor, introduce una fecha válida.';
                      }
                      
                      return null;
                    },
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
                  SizedBox(height: 10),
                  TextFormField(
                    style: TextStyle(color: const Color.fromARGB(255,48,25,95)),
                    controller: juegoController,
                    decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                prefixIcon: Icon(Icons.sports_esports, color: Color.fromARGB(255, 255,255,255),),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[700]),
                hintText: "Juego",
                fillColor: const Color.fromARGB(255,229,203,93)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce una juego.';
                      }
                      if (value.length < 4) {
                        return 'Por favor, introduce un juego válido.';
                      }
                      if (value.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) {
                        return 'Por favor, no uses caracteres especiales.';
                      }
                      if (value.contains(',')) {
                        return 'Por favor, no uses comas.';
                      }
                      if (value.contains(RegExp(r'^[0-9]'))) {
                        return 'Por favor, no empieces por números.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      juego = value;
                      id = "0";
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
              style: TextStyle(color: const Color.fromARGB(255,48,25,95)),
                    controller: lista_reglasControler,
                    decoration: InputDecoration(
                prefixIcon: Icon(Icons.rule, color: Color.fromARGB(255, 255,255,255)),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[700]),
                hintText: "Lista de reglas (separadas por comas)",
                fillColor: const Color.fromARGB(255,229,203,93)),
              validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce una Lista de reglas.';
                      }
                      if (value.length < 4) {
                        return 'Por favor, introduce una lista de reglas válida.';
                      }
                      if (value.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) {
                        return 'Por favor, no uses caracteres especiales.';
                      }
                      if (value.contains('.')) {
                        return 'Por favor, usa comas en vez de puntos.';
                      }
                      if (value.contains(RegExp(r'^[0-9]'))) {
                        return 'Por favor, no empieces por números.';
                      }
                      
                      return null;
                    },
              onChanged: (value) {
                lista_reglas = value.split(',');
              },
                        ),
                  SizedBox(height: 10),
              TextFormField(
              style: TextStyle(color: const Color.fromARGB(255,48,25,95)),
                    controller: premiosController,
                    decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[700]),
                hintText: "Premios (separados por comas)",
                prefixIcon: Icon(Icons.emoji_events, color: Color.fromARGB(255, 255,255,255)),
                fillColor: const Color.fromARGB(255,229,203,93)),
              validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce un premio.';
                      }
                      if (value.length < 4) {
                        return 'Por favor, introduce un premio válido.';
                      }
                      if (value.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) {
                        return 'Por favor, no uses caracteres especiales.';
                      }
                      if (value.contains(',')) {
                        return 'Por favor, usa puntos en vez de comas.';
                      }
                      
                      return null;
                    },
              onChanged: (value) {
                premios = value.split(',');
              },
                        ),
                  SizedBox(height: 10),
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
          ),
        ],
      ),
    );
  }
}