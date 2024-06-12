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
    final nombreController = TextEditingController();
  final juegoController = TextEditingController();
  final edadController = TextEditingController();
  final selectedEquipoIdcontroller = TextEditingController();
  final caracteristicasController = TextEditingController();

  // Getter para obtener los nombres de equipo
Future<void> fetchEquipos() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/equipos/'));
  if (response.statusCode == 200) {
    equipos = jsonDecode(response.body);
    if (equipos.isNotEmpty) {
      setState(() {
        selectedEquipoId = equipos[0]['id'];
      });
    }
    print(equipos);
  } else {
    throw Exception('Failed to fetch equipos.');
  }
}
  // Post para los jugadores
  Future<void> addJugador(String nombre, String juego, int edad,
      String caracteristicas, int id, int equipo_id) async {
        if (_formKey.currentState!.validate()) {
        final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/jugadores/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': 0,
        'nombre': nombreController.text,
        'juego': juegoController.text,
        'edad': edadController.text,
        'caracteristicas': caracteristicasController.text,
        'equipo_id': selectedEquipoIdcontroller.text,
        }),
    );

    if (response.statusCode == 200) {
      print('Jugador añadido con éxito');
    } else {
      throw Exception('Failed to add jugador.');
    }
  } else {
    print('Por favor, completa todos los campos correctamente.');
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
            SingleChildScrollView(
              child: 
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nombre Jugador', fillColor: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa un nombre';
                        }
                        if (value.length < 4) {
                          return 'Por favor, ingresa al menos 5 caracteres';
                        }
                        if (value.length > 50) {
                          return 'Por favor, ingresa menos de 50 caracteres';
                        }
                        if (value.contains(RegExp(r'[0-9]'))) {
                          return 'Por favor, no uses numeros';
                        }
                        if (value.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) {
                          return 'Por favor, no uses caracteres especiales';
                        }
                        if (value.contains(',')) {
                          return 'Por favor, no uses comas';
                        }
                        
                        return null;
                      
                      },
                      onChanged: (value) {
                        nombre = value;
                        id = 0;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Juego jugador'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa un juego';
                        }
                        //caracteres especiales
                        if (value.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) {
                          return 'Por favor, no uses caracteres especiales';
                        }
                        //comas
                        if (value.contains(',')) {
                          return 'Por favor, no uses comas';
                        }
                        
                        juego = value.toUpperCase();
                        
                        return null;
                      
                      },
                      onChanged: (value) {
                        juego = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Edad Jugador'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa una edad';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor, ingresa un valor numerico';
                        }
                        if (int.tryParse(value)! < 0) {
                          return 'Por favor, ingresa un valor positivo';
                        }
                        if (int.tryParse(value)! > 100) {
                          return 'Por favor, ingresa un valor menor a 100';
                        }
                        if (value.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) {
                          return 'Por favor, no uses caracteres especiales';
                        }
                        if (value.startsWith('0')) {
                          return 'Por favor, no empieces por 0';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        int? edad = int.tryParse(value);
                        if (edad == null) {
                        
                        }
                      },
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Caracteristicas del Jugador'),
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa las caracteristicas';
                        }
                        if (value.length < 5) {
                          return 'Por favor, ingresa al menos 10 caracteres';
                        }
                        if (value.length > 100) {
                          return 'Por favor, ingresa menos de 100 caracteres';
                        }
                        if (value.contains(' ')) {
                          return 'Por favor, no uses espacios';
                        }
                        if (value.contains(RegExp(r'[0-9]'))) {
                          return 'Por favor, no uses numeros';
                        }
                        if (value.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) {
                          return 'Por favor, no uses caracteres especiales';
                        }                      
                        return null;
                      },
                      onChanged: (value) {
                        caracteristicas = value;
                      },
                    ),
                  DropdownButton(
                    value: selectedEquipoId,
                    hint: Text('Selecciona un equipo'),
                    onChanged: (int? nuevoValor) {
                      setState(() {
                        selectedEquipoId = nuevoValor!;
                      });
                    },
                    items: equipos.map<DropdownMenuItem<int>>((equipo) {
                      return DropdownMenuItem<int>(
                        value: equipo['id'],
                        child: Text(equipo['nombre']),
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
            ),
          ],
        ));
  }
}
