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
                title: Text('AÑADIR JUGADORES'),
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
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
              child: SingleChildScrollView(
                child: 
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10),
                      TextFormField(
                        style: TextStyle(color: Colors.amber),
                        decoration: InputDecoration(labelText: 'Nombre Jugador',labelStyle: TextStyle(color: Colors.white),filled: true, fillColor: const Color.fromARGB(255, 48, 25, 95), prefixIcon: Icon(Icons.person,color: Colors.amber),
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
                      SizedBox(height: 10),
                      TextFormField(
                        style: TextStyle(color: Colors.amber),
                        decoration: InputDecoration(labelText: 'Juego jugador',labelStyle: TextStyle(color: Colors.white),filled: true, fillColor: const Color.fromARGB(255, 48, 25, 95), prefixIcon: Icon(Icons.games, color: Colors.amber,),
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
                      SizedBox(height: 10),
                      TextFormField(
                        style: TextStyle(color: Colors.amber),
                        decoration: InputDecoration(labelText: 'Edad Jugador',labelStyle: TextStyle(color: Colors.white) ,hoverColor: Colors.white,filled: true, fillColor: const Color.fromARGB(255, 48, 25, 95), prefixIcon: Icon(Icons.date_range_outlined, color: Colors.amber),
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
                      SizedBox(height: 10),
                      TextFormField(
                        style: TextStyle(color: Colors.amber),
                        decoration:
                            InputDecoration(labelText: 'Caracteristicas del Jugador',labelStyle: TextStyle(color: Colors.white),filled: true, fillColor: const Color.fromARGB(255, 48, 25, 95), prefixIcon: Icon(Icons.my_library_books,color: Colors.amber),
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
                      SizedBox(height: 10),
                    DropdownButton(
                      dropdownColor: Color.fromARGB(255, 0, 0, 0),
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
                          child: Text(equipo['nombre'], style: TextStyle(color: Color.fromARGB(255, 255, 230, 0))),
                        );
                      }).toList(),
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
    padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(10.0)), // Espaciado interno
  ),
                        onPressed: () async {
                          await addJugador(nombre, juego, edad, caracteristicas, id,
                              selectedEquipoId);
                          setState(() {});
                        },
                        child: Text('Añadir jugador', style: TextStyle(color: Colors.amber),
                  )),
                      
                    ],
                  ),
                )
              ),
            ),
          ],
        ));
  }
}
