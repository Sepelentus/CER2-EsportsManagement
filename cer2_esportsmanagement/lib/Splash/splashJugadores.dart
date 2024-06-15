import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JugadoresPage extends StatefulWidget {
  final int equipoId;

  JugadoresPage({required this.equipoId});

  @override
  _JugadoresPageState createState() => _JugadoresPageState();
}

class _JugadoresPageState extends State<JugadoresPage> {
  List<Map<String, dynamic>> jugadores = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> deleteJugador(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Jugador'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que quieres eliminar este jugador?'),
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
              child: Text('Eliminar'),
              onPressed: () async {
                final response = await http
                    .delete(Uri.parse('http://10.0.2.2:8000/jugadores/$id'));

                if (response.statusCode == 200) {
                  print('Jugador deleted successfully.');
                  Navigator.of(context).pop();
                } else {
                  print(
                      'Failed to delete jugador. Status code: ${response.statusCode}');
                  print('Response body: ${response.body}');
                  throw Exception('Failed to delete jugador.');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateJugador(int id, String nombre, String juego, int edad,
      String caracteristicas, int equipo_id) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/jugadores/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'nombre': nombre,
        'juego': juego,
        'edad': edad,
        'caracteristicas': caracteristicas,
        'equipo_id': equipo_id,
      }),
    );

    if (response.statusCode == 200) {
      print('Jugador updated successfully.');
    } else {
      print('Failed to update jugador. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update jugador.');
    }
  }

  Future<void> fetchData() async {
    var responseJugadores =
        await http.get(Uri.parse('http://10.0.2.2:8000/jugadores/'));
    var responseEquipos =
        await http.get(Uri.parse('http://10.0.2.2:8000/equipos/'));

    if (responseJugadores.statusCode == 200 &&
        responseEquipos.statusCode == 200) {
      List<dynamic> jugadoresData = json.decode(responseJugadores.body);
      List<dynamic> equiposData = json.decode(responseEquipos.body);

      setState(() {
        jugadores = jugadoresData
            .where((jugador) => jugador['equipo_id'] == widget.equipoId)
            .map((jugador) {
          var equipo = equiposData.firstWhere(
              (equipo) => equipo['id'] == jugador['equipo_id'],
              orElse: () => null);
          return {
            'id': jugador['id'],
            'nombre': jugador['nombre'],
            'caracteristicas': jugador['caracteristicas'],
            'edad': jugador['edad'],
            'juego': jugador['juego'],
            'equipo_id': jugador['equipo_id'],
            'equipo_nombre': equipo != null ? equipo['nombre'] : 'Unknown',
          };
        }).toList();
      });
    } else {
      print(
          'Error con la petición: ${responseJugadores.statusCode}, ${responseEquipos.statusCode}');
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
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wall.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: jugadores.length,
          itemBuilder: (context, index) {
            return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  //title: Text(' ${jugadores[index]['nombre']} - ${jugadores[index]['caracteristicas']}', style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
                  //subtitle: Text('Equipo: ${jugadores[index]['equipo_nombre']}', style: TextStyle(color: const Color.fromARGB(255, 255, 251, 251))) );
                ),
                margin: EdgeInsets.all(10),
                elevation: 14,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/walljuga.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(' ${jugadores[index]['nombre']}',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 229, 203, 93))),
                        leading: Icon(
                          Icons.person_2_outlined,
                          size: 35,
                          color: const Color.fromARGB(255, 229, 203, 93),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 20,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Editar Jugador'),
                                      content: Column(
                                        children: <Widget>[
                                          TextFormField(
                                            initialValue: jugadores[index]
                                                ['nombre'],
                                            onChanged: (value) {
                                              jugadores[index]['nombre'] =
                                                  value;
                                            },
                                          ),
                                          TextFormField(
                                            initialValue: jugadores[index]
                                                ['caracteristicas'],
                                            onChanged: (value) {
                                              jugadores[index]
                                                  ['caracteristicas'] = value;
                                            },
                                          ),
                                          TextFormField(
                                            initialValue: jugadores[index]
                                                    ['edad']
                                                .toString(),
                                            onChanged: (value) {
                                              jugadores[index]['edad'] =
                                                  int.parse(value);
                                            },
                                          ),
                                          TextFormField(
                                            enabled: false,
                                            initialValue: jugadores[index]
                                                    ['equipo_nombre']
                                                .toString(),
                                            onChanged: (value) {
                                              jugadores[index]['equipo_id'] =
                                                  int.parse(value);
                                            },
                                          ),
                                        ],
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
                                          onPressed: () async {
                                            String nombre = jugadores[index]
                                                    ['nombre'] ??
                                                '';
                                            String juego =
                                                jugadores[index]['juego'] ?? '';
                                            int edad =
                                                jugadores[index]['edad'] ?? 0;
                                            String caracteristicas =
                                                jugadores[index]
                                                        ['caracteristicas'] ??
                                                    '';
                                            int equipo_id = jugadores[index]
                                                    ['equipo_id'] ??
                                                0;
                                            await updateJugador(
                                                jugadores[index]['id'],
                                                nombre,
                                                juego,
                                                edad,
                                                caracteristicas,
                                                equipo_id);
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
                                await deleteJugador(jugadores[index]['id']);
                                setState(() {});
                              },
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color:
                                      const Color.fromARGB(255, 229, 203, 93),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Información del Jugador'),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                'Nombre: ${jugadores[index]['nombre']}'),
                                            Text(
                                                'Equipo: ${jugadores[index]['equipo_nombre']}'),
                                            Text(
                                                'Juego: ${jugadores[index]['juego']}'),
                                            Text(
                                                'Características: ${jugadores[index]['caracteristicas']}'),
                                            Text(
                                                'Edad: ${jugadores[index]['edad']}'),
                                          ],
                                        ),
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
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
          },
        ),
      ]),
    );
  }
}
