import 'package:cer2_esportsmanagement/Add/splashAddDCampeonato.dart';
import 'package:cer2_esportsmanagement/Vistas/equipos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:icons_plus/icons_plus.dart';

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
Future<void> updateCampeonato(String fecha, String juego, List<String> lista_reglas, List<String> premios, String id) async {
  final response = await http.put(
    Uri.parse('http://10.0.2.2:8000/campeonatos/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
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
  final response = await http.delete(Uri.parse('http://10.0.2.2:8000/campeonatos/${id}'));

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
  final _formKey = GlobalKey<FormState>();
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
          
          FutureBuilder<List<Campeonato>>(
            future: fetchCampeonatos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(5),
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/Cardwall.jpg"), // Reemplaza esto con la ruta de tu imagen
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                BoxIcons.bx_trophy,
                                size: 50, color: Colors.amber,
                              ),
                              title: Text(snapshot.data![index].juego,
                                  style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      letterSpacing: 4, color: Colors.amber)),
                              subtitle: Text( style: TextStyle(color: Colors.white),
                                  'Fecha: ${snapshot.data![index].fecha}\nReglas: ${snapshot.data![index].lista_reglas.join(', ')}\nPremios: ${snapshot.data![index].premios.join(', ')}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                IconButton(
  icon: Icon(Icons.edit),
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Campeonato'),
          content: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
  initialValue: snapshot.data![index].juego,
  decoration: InputDecoration(labelText: 'Nombre del Juego'),
  onSaved: (value) {
    // Asegúrate de que updateCampeonato acepta los mismos parámetros que addCampeonato
    updateCampeonato(fecha, juego, lista_reglas, premios, id);
  },
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save(); // Esto desencadenará el onSaved de TextFormField
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  },
),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red, size: 30,),
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirmar eliminación'),
                                          content: Text('¿Estás seguro de que quieres eliminar este campeonato?'),
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
                                                await deleteCampeonato(snapshot.data![index].id);
                                                Navigator.of(context).pop(); // Recarga la página
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
                                          builder: (context) => VistaEquipos()),
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
      floatingActionButton:
          FloatingActionButton(
              onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => Splashadddcampeonato()));
              },
              child: Icon(Icons.add),
              backgroundColor: const Color.fromARGB(255,229,203,93),
            ),

      
    );
  }
}
