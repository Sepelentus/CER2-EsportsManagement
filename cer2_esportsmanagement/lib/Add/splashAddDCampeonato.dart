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
        'lista_reglas': lista_reglas,
        'premios': premios,
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
          title: Text('AÑADIR CAMPEONATOS'),
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
                    decoration: InputDecoration(labelText: 'Fecha de campeonato',labelStyle: TextStyle(color: Colors.white),filled: true, fillColor: const Color.fromARGB(255, 48, 25, 95), prefixIcon: Icon(Icons.date_range_outlined,color: Colors.amber),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.amber, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.amber, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.amber, width: 2.0),
                      ),
                        ),
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
                    decoration: InputDecoration(labelText: 'Juego',labelStyle: TextStyle(color: Colors.white),filled: true, fillColor: const Color.fromARGB(255, 48, 25, 95), prefixIcon: Icon(Icons.sports_esports_outlined,color: Colors.amber),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.amber, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.amber, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.amber, width: 2.0),
                      ),
                        ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce una juego.';
                      }
                      if (value.length < 4) {
                        return 'Por favor, introduce un juego válido.';
                      }
                      if (value.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]'))) {
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
                    decoration: InputDecoration(labelText: 'Lista de reglas (Separados por Coma)',labelStyle: TextStyle(color: Colors.white),filled: true, fillColor: const Color.fromARGB(255, 48, 25, 95), prefixIcon: Icon(Icons.my_library_books,color: Colors.amber),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.amber, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.amber, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.amber, width: 2.0),
                      ),
                        ),
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
                    decoration: InputDecoration(labelText: 'Premios (Separados por Coma)',labelStyle: TextStyle(color: Colors.white),filled: true, fillColor: const Color.fromARGB(255, 48, 25, 95), prefixIcon: Icon(Icons.my_library_books,color: Colors.amber),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.amber, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.amber, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.amber, width: 2.0),
                      ),
                        ),
              validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce un premio.';
                      }
                      if (value.length < 4) {
                        return 'Por favor, introduce un premio válido.';
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
                    style: ButtonStyle( backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255,48,25,95)), // Color de fondo
    shape: WidgetStateProperty.all<RoundedRectangleBorder>( // Forma y borde
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(color: Colors.amber, width: 2.0),
      ),
    ),
    padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(10.0)), 
  ),
                    onPressed: () async {
                        await addCampeonato(fecha, juego, lista_reglas, premios, id);
                        setState(() {
                        });
                    },
                    child: Text('Añadir Campeonato', style: TextStyle(color: Colors.amber),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}