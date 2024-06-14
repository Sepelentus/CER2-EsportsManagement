import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

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
  int selectedFirstEquipoId = 3;
  int selectedSecondEquipoId = 4;
  // Lista de campeonatos
  List<dynamic> campeonatos = [];
  int selectedCampeonatoId = 1;

  // Getter para obtener los nombres de equipo
  Future<void> fetchEquipos() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/equipos/'));
    if (response.statusCode == 200) {
      equipos = jsonDecode(response.body);
      if (equipos.isNotEmpty) {
        setState(() {
          selectedFirstEquipoId = equipos[0]['id'];
        });
      }
      print(equipos);
    } else {
      throw Exception('Failed to fetch equipos.');
    }
  }

  Future<void> fetchCampeonatos() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/campeonatos/'));
    if (response.statusCode == 200) {
      campeonatos = jsonDecode(response.body);
      if (campeonatos.isNotEmpty) {
        setState(() {
          selectedCampeonatoId = campeonatos[0]['id'];
        });
      }
      print(campeonatos);
    } else {
      throw Exception('Failed to fetch campeonatos.');
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
    if (_formKey.currentState!.validate()) {
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
  }

  @override
  void initState() {
    super.initState();
    fetchEquipos();
    fetchCampeonatos();
  }

  // Hacer widgets correspondientes futuro developer de aqui
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
                title: Text('AÑADIR PARTIDOS'),
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
              image: DecorationImage(
                image: AssetImage('assets/images/wall.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
              child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10),
                            TextFormField(
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 230, 0)),
                              controller: fechaController,
                              decoration: InputDecoration(
                                labelText: 'Fecha de partido',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 48, 25, 95),
                                prefixIcon: Icon(Icons.date_range_outlined,
                                    color: Colors.amber),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 2.0),
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
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  final TimeOfDay? pickedTime =
                                      await showTimePicker(
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
                                    fecha = DateFormat(
                                            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                        .format(finalDateTime.toUtc());
                                        
                                    fechaController.text = fecha;
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            DropdownButton(
                              dropdownColor: Color.fromARGB(255, 0, 0, 0),
                              value: selectedFirstEquipoId,
                              hint: Text('Selecciona el primer equipo'),
                              onChanged: (int? nuevoValor) {
                                setState(() {
                                  selectedFirstEquipoId = nuevoValor!;
                                });
                              },
                              items:
                                  equipos.map<DropdownMenuItem<int>>((equipo) {
                                return DropdownMenuItem<int>(
                                  value: equipo['id'],
                                  child: Text(equipo['nombre'],
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 230, 0))),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            DropdownButton(
                              dropdownColor: Color.fromARGB(255, 0, 0, 0),
                              value: selectedSecondEquipoId,
                              hint: Text('Selecciona el segundo equipo'),
                              onChanged: (int? nuevoValor) {
                                setState(() {
                                  selectedSecondEquipoId = nuevoValor!;
                                  print(
                                      'Primer valor -> ${selectedFirstEquipoId}, Segundo valor -> ${selectedSecondEquipoId}');
                                });
                              },
                              items:
                                  equipos.map<DropdownMenuItem<int>>((equipo) {
                                return DropdownMenuItem<int>(
                                  value: equipo['id'],
                                  child: Text(equipo['nombre'],
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 230, 0))),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              style: TextStyle(color: Colors.amber),
                              decoration: InputDecoration(
                                labelText: 'Lugar de la partida',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 48, 25, 95),
                                prefixIcon: Icon(
                                  Icons.pin_drop,
                                  color: Colors.amber,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 2.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingresa un lugar';
                                }
                                //caracteres especiales
                                if (value.contains(RegExp(
                                    r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))) {
                                  return 'Por favor, no uses caracteres especiales';
                                }
                                //comas
                                if (value.contains(',')) {
                                  return 'Por favor, no uses comas';
                                }
                                lugar = value.toUpperCase();
                                return null;
                              },
                              onChanged: (value) {
                                lugar = value;
                              },
                            ),
                            SizedBox(height: 10),
                            DropdownButton(
                              dropdownColor: Color.fromARGB(255, 0, 0, 0),
                              value: selectedCampeonatoId,
                              hint: Text('Selecciona un campeonato'),
                              onChanged: (int? nuevoValor) {
                                setState(() {
                                  selectedCampeonatoId = nuevoValor!;
                                });
                              },
                              items: campeonatos
                                  .map<DropdownMenuItem<int>>((campeonato) {
                                return DropdownMenuItem<int>(
                                  value: campeonato['id'],
                                  child: Text(campeonato['juego'],
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 230, 0))),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          const Color.fromARGB(255, 48, 25,
                                              95)), // Color de fondo
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    // Forma y borde
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(
                                          color: Colors.amber, width: 2.0),
                                    ),
                                  ),
                                  padding: WidgetStateProperty.all<EdgeInsets>(
                                      EdgeInsets.all(
                                          10.0)), // Espaciado interno
                                ),
                                onPressed: () async {
                                  equipos_ids.add(selectedFirstEquipoId);
                                  equipos_ids.add(selectedSecondEquipoId);
                                  await addPartido(
                                    fecha,
                                    equipos_ids,
                                    lugar,
                                    selectedCampeonatoId,
                                    id,
                                  );
                                  setState(() {});
                                },
                                child: Text(
                                  'Añadir Partido',
                                  style: TextStyle(color: Colors.amber),
                                )),
                          ]))))
        ]));
  }
}
