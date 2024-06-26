import 'package:cer2_esportsmanagement/Add/splashAddDCampeonato.dart';
import 'package:cer2_esportsmanagement/Vistas/equipos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class Campeonato {
  final int id;
  final String fecha;
  final String juego;
  final List<String> lista_reglas;
  final List<String> premios;

  Campeonato({
    required this.id,
    required this.fecha,
    required this.juego,
    required this.lista_reglas,
    required this.premios,
  });

  factory Campeonato.fromJson(Map<String, dynamic> json) {
    return Campeonato(
      id: json['id'],
      fecha: json['fecha'],
      juego: json['juego'],
      lista_reglas: List<String>.from(json['lista_reglas'].map((x) => x)),
      premios: List<String>.from(json['premios'].map((x) => x)),
    );
  }
}

Future<List<Campeonato>> fetchCampeonatos() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:8000/campeonatos/'));
  if (response.statusCode == 200) {
    List<dynamic> campeonatosJson = jsonDecode(response.body);
    return campeonatosJson.map((json) => Campeonato.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load campeonatos');
  }
}

Future<void> updateCampeonato(String fecha, String juego,
    List<String> lista_reglas, List<String> premios, int id) async {
  final response = await http.put(
    Uri.parse('http://10.0.2.2:8000/campeonatos/$id'), 
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id': id,
      'fecha': fecha,
      'juego': juego,
      'lista_reglas': lista_reglas,
      'premios': premios,
    }),
  );

  if (response.statusCode == 200) {
    print('Campeonato updated successfully.');
  } else {
    print('Failed to update campeonato. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to update campeonato.');
  }
}

Future<void> deleteCampeonato(int id) async {
  final response =
      await http.delete(Uri.parse('http://10.0.2.2:8000/campeonatos/${id}'));

  if (response.statusCode == 200) {
    print('Campeonato deleted successfully.');
  } else {
    print('Failed to delete campeonato. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to delete campeonato.');
  }
}
// ignore: must_be_immutable
class SplashCampeonatos extends StatelessWidget {
  String fecha = '';
  String juego = '';
  String id = '';
  List<String> lista_reglas = [];
  List<String> premios = [];
  final fechaController = TextEditingController();
  SplashCampeonatos({Key? key}) : super(key: key);

  get campeonatoId => 0;

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
          SizedBox(height: 10),
          FutureBuilder<List<Campeonato>>(
            future: fetchCampeonatos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26)),
                      margin: EdgeInsets.all(5),
                      elevation: 10,
                      
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/Cardwall.jpg"), 
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                BoxIcons.bx_trophy,
                                size: 50,
                                color: Colors.amber,
                              ),
                              title: Text(snapshot.data![index].juego,
                                  style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      letterSpacing: 4,
                                      color: Colors.amber)),
                              subtitle: Text(
                                  style: TextStyle(color: Colors.white),
                                  'Fecha: ${snapshot.data![index].fecha}\nReglas: ${snapshot.data![index].lista_reglas.join(', ')}\nPremios: ${snapshot.data![index].premios.join(', ')}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.edit), color: Colors.white,
                                      onPressed: () {
                                        TextEditingController idController = TextEditingController(text: snapshot.data![index].id.toString());
                                        TextEditingController fechaController = TextEditingController(text: snapshot.data![index].fecha);
                                        TextEditingController juegoController = TextEditingController(text: snapshot.data![index].juego);
                                        TextEditingController reglasController = TextEditingController(text: snapshot.data![index].lista_reglas.join(', '));
                                        TextEditingController premiosController = TextEditingController(text: snapshot.data![index].premios.join(', '));
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Editar Campeonato'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    TextField(
                                                      controller: idController,
                                                      decoration: InputDecoration(hintText: "ID"),
                                                      enabled: false, // Esto hace que el TextField sea de solo lectura
                                                    ),
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
                                                    TextField(
                                                      controller: juegoController,
                                                      decoration: InputDecoration(hintText: "Juego"),
                                                    ),
                                                    TextField(
                                                      controller: reglasController,
                                                      decoration: InputDecoration(hintText: "Reglas"),
                                                    ),
                                                    TextField(
                                                      controller: premiosController,
                                                      decoration: InputDecoration(hintText: "Premios"),
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
                                                  onPressed: () {
                                                    updateCampeonato(fechaController.text, juegoController.text, reglasController.text.split(','), premiosController.text.split(','), int.parse(idController.text));
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    )
                                  ,IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:
                                                Text('Confirmar eliminación'),
                                            content: Text(
                                                '¿Estás seguro de que quieres eliminar este campeonato?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Cancelar'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Eliminar'),
                                                onPressed: () async {
                                                  await deleteCampeonato(
                                                      snapshot.data![index].id);
                                                  Navigator.of(context)
                                                      .pop(); // Recarga la página
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ButtonBar(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ElevatedButton(
                                  child: Text('Ver Equipos'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VistaEquipos(campeonatoId: snapshot.data![index].id)),
                                    );
                                  },
                                ),
                              ],
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
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              ));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Splashadddcampeonato()));
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 229, 203, 93),
      ),
    );
  }
}
