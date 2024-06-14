import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Splashaddresultado extends StatefulWidget {
  @override
  State<Splashaddresultado> createState() => _SplashaddresultadoState();
}

class _SplashaddresultadoState extends State<Splashaddresultado> {
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  String result = '';
  int partido_id = 0;

  //Lista de partidos
  List<dynamic> partidos = [];
  int selectedPartidoId = 1;

  Future<void> fetchPartidos() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/partidos/'));
    if (response.statusCode == 200) {
      partidos = jsonDecode(response.body);
      if (partidos.isNotEmpty) {
        setState(() {
          selectedPartidoId = partidos[0]['id'];
        });
      }
      print(partidos);
    } else {
      throw Exception('Failed to fetch equipos.');
    }
  }

  // Post para los jugadores
  Future<void> addResultado(
    String result,
    int partido_id,
    int id,
  ) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/resultados/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': 0,
        'result': result,
        'partido_id': partido_id
      }),
    );
    if (response.statusCode == 200) {
      print('Resultado añadido con éxito.');
    } else {
      throw Exception('Failed to add resultado.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPartidos();
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
                              style: TextStyle(color: Colors.amber),
                              decoration: InputDecoration(
                                labelText: 'Resultado del partida',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 48, 25, 95),
                                prefixIcon: Icon(
                                  Icons.list,
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
                                  return 'Por favor, ingresa un resultado';
                                }                                
                                if (value.length < 2) {
                                  return 'El resultado debe tener al menos 2 caracteres';
                                }
                                if (value.length > 10) {
                                  return 'El resultado no puede tener más de 20 caracteres';
                                }
                                //comas
                                if (value.contains(',')) {
                                  return 'Por favor, no uses comas';
                                }
                                result = value;
                                return null;
                              },
                              onChanged: (value) {
                                result = value;
                                id = 0;
                              },
                            ),
                            SizedBox(height: 10),
                            DropdownButton(
                              dropdownColor: Color.fromARGB(255, 0, 0, 0),
                              value: selectedPartidoId,
                              hint: Text('Selecciona la ID del partido'),
                              onChanged: (int? nuevoValor) {
                                setState(() {
                                  selectedPartidoId = nuevoValor!;
                                });
                              },
                              items:
                                  partidos.map<DropdownMenuItem<int>>((partido) {
                                return DropdownMenuItem<int>(
                                  value: partido['id'],
                                  child: Text('${partido['id']}',
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
                                  await addResultado(
                                    result,
                                    selectedPartidoId,
                                    id,
                                  );
                                  setState(() {});
                                },
                                child: Text(
                                  'Añadir resultado',
                                  style: TextStyle(color: Colors.amber),
                                )),
                          ]
                          ))))
        ]));
  }
}
