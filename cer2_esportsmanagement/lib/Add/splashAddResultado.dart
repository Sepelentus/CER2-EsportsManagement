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
  int partido_id = 0;// Asume que el ID es un entero, ajusta según sea necesario
  List<String> nombresEquipos = []; // Inicializado como lista vacía
  String? selectedEquipo; 


  

  //Lista de partidos
  List<dynamic> partidos = [];
  int selectedPartidoId = 1;

  Future<String> fetchNombreEquipo(int equipoId) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/equipos/$equipoId'));
  if (response.statusCode == 200) {
    final equipo = jsonDecode(response.body);
    return equipo['nombre']; // Asumiendo que la respuesta tiene un campo 'nombre'
  } else {
    throw Exception('Failed to fetch equipo.');
  }
}

Future<void> fetchPartidos() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/partidos/'));
  if (response.statusCode == 200) {
    List<dynamic> fetchedPartidos = jsonDecode(response.body);
    List<String> tempNombresEquipos = [];
    for (var partido in fetchedPartidos) {
      // Verificar que partido['equipos_ids'] contiene al menos dos elementos
      if (partido['equipos_ids'] != null && partido['equipos_ids'].length >= 2) {
        String nombreEquipoLocal = await fetchNombreEquipo(partido['equipos_ids'][0]);
        String nombreEquipoVisitante = await fetchNombreEquipo(partido['equipos_ids'][1]);
        tempNombresEquipos.add('$nombreEquipoLocal VS $nombreEquipoVisitante');
      } else {
        // Manejar el caso en que no hay suficientes equipos_ids
        // Por ejemplo, agregando un nombre de equipo predeterminado o saltando este partido
        continue; // O manejar de otra manera
      }
    }
    setState(() {
      partidos = fetchedPartidos;
      nombresEquipos = tempNombresEquipos;
      // Asegurarse de que selectedPartidoId tenga un valor válido
      selectedPartidoId = partidos.isNotEmpty ? partidos[0]['id'] : 0;
    });
  } else {
    throw Exception('Failed to fetch partidos.');
  }
}
  Future<List<String>> fetchNombresEquipos(List<int> equiposIds) async {
  List<String> nombresEquipos = [];
  for (int id in equiposIds) {
    final nombreEquipo = await fetchNombreEquipo(id); // Utiliza la función existente para obtener el nombre por ID
    nombresEquipos.add(nombreEquipo);
  }
  return nombresEquipos;
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
                title: Text('AÑADIR RESULTADO'),
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
                                value: selectedEquipo,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedEquipo = newValue!;
                                  });
                                },
                                items: nombresEquipos.map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
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
