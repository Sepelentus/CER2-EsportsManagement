import 'dart:convert';
import 'package:cer2_esportsmanagement/Add/splashAddEquipos.dart';
import 'package:cer2_esportsmanagement/Splash/splashJugadores.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class VistaEquipos extends StatefulWidget {
  String nombre = '';
  String id = '';
  List<dynamic> equipos = [];

  @override
  State<VistaEquipos> createState() => _VistaEquiposState();
}

class Equipo {
  final int id;
  final String nombre;

  Equipo({required this.id, required this.nombre});

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}

Future<List<Equipo>> fetchEquipos() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/equipos/'));
  if (response.statusCode == 200) {
    List<dynamic> equiposJson = jsonDecode(response.body);
    return equiposJson.map((json) => Equipo.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load equipos');
  }
}

Future<List<dynamic>> fetchJugadores() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/jugadores'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load jugadores');
  }
}

Future<void> deleteEquipos(BuildContext context, int id) async {
  final jugadores = await fetchJugadores();
  final jugadoresDelEquipo = jugadores.where((jugador) => jugador['equipo_id'] == id).toList();

  if (jugadoresDelEquipo.isNotEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Tienes jugadores en el equipo. Eliminalos primero antes de eliminar el equipo.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return;
  }

  final response = await http.delete(Uri.parse('http://10.0.2.2:8000/equipos/$id'));

  if (response.statusCode != 200) {
    print('Failed to delete equipo. Status code: ${response.statusCode}. Body: ${response.body}');
    throw Exception('Failed to delete equipo.');
  }
}

Future<void> updateEquipo(int id, String nombre) async {
  final response = await http.put(
    Uri.parse('http://10.0.2.2:8000/equipos/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id' : id,
      'nombre': nombre,
    }),
  );

  if (response.statusCode == 200) {
    print(' updated successfully.');
  } else {
    print('Failed to update  Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to update ');
  }
}

class _VistaEquiposState extends State<VistaEquipos> {
  late Future<List<Equipo>> futureEquipos;

  @override
  void initState() {
    super.initState();
    futureEquipos = fetchEquipos();
    //deleteEquipos(0);
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
              title: Text('EQUIPOS'),
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
          FutureBuilder<List<Equipo>>(
            future: futureEquipos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.all(10),
                      elevation: 14,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/wallequipos_updated.jpg"), 
                            fit: BoxFit.cover,
                          ),
                        ),
                      child: Column(
                      children: [
                        ListTile(
                          title: Text(snapshot.data![index].nombre, style: TextStyle(fontSize: 18, 
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.bold,
                          
                          color: Color.fromARGB(255,229,203,93))),
                          leading: Icon(Icons.sports_esports, size: 35, color: const Color.fromARGB(255,229,203,93),),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, size: 20,),
                                color: Colors.white,
                                onPressed: () {
                                  TextEditingController idController = TextEditingController(text: snapshot.data![index].id.toString());
                                  TextEditingController nombreController = TextEditingController(text: snapshot.data![index].nombre);
                                showDialog(
                                  context: context,
                                    builder: (context) {
                                    return AlertDialog(
                                      title: Text('Editar Equipo'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            TextField(
                                            controller: idController,
                                            decoration: InputDecoration(hintText: "ID"),
                                            enabled: false, // Esto hace que el TextField sea de solo lectura
                                            ),
                                            TextFormField(
                                              controller: nombreController,
                                              decoration: InputDecoration(hintText: 'Nombre del equipo'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Guardar'),
                                          onPressed: ()  {
                                            updateEquipo(int.parse(idController.text), nombreController.text);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                },
                              ),
                              IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 20,
                              ),
                              color: Colors.red,
                              onPressed: () async {
                                await deleteEquipos(context,snapshot.data![index].id);
                                setState(() {
                                  //equipos.removeAt(index);
                                });
                              },
                            ),
                              IconButton(
                                icon : Icon(Icons.arrow_forward_ios, size: 20, color: const Color.fromARGB(255,229,203,93),),
                                onPressed: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder:(context) => JugadoresPage(equipoId: int.parse(snapshot.data![index].id.toString())),
                                    )
                                  );
                                  print(snapshot.data![index].id);
                                }
                              ),
                              
                            ],
                          ),
                          tileColor: const Color.fromARGB(255,229,203,93),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                    ),
                    );

                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder:(context) => AgregarEquipo()));
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255,229,203,93),
      ),
    );
  }
}