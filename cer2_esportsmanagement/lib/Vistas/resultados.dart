import 'dart:convert';

import 'package:cer2_esportsmanagement/Add/splashAddResultado.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';

class Resultado{
  final int id;
  final String result;
  final int partido_id;

  Resultado({
    required this.id,
    required this.result,
    required this.partido_id,
  });


  factory Resultado.fromJson(Map<String, dynamic> json) {
    return Resultado(
      id: json['id'],
      result: json['result'],
      partido_id: json['partido_id']
    );
  }
}

Future<List<Resultado>> fetchResultados() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:8000/resultados/'));
  if (response.statusCode == 200) {
    List<dynamic> resultadosJson = jsonDecode(response.body);
    return resultadosJson.map((json) => Resultado.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load resultados');
  }
}

Future<void> deleteResultado(int id) async {
  final response =
      await http.delete(Uri.parse('http://10.0.2.2:8000/resultados/${id}'));

  if (response.statusCode == 200) {
    print('Resultado deleted successfully.');
  } else {
    print('Failed to delete resultado. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to delete resultado.');
  }
}

// ignore: must_be_immutable
class VistaResultados extends StatelessWidget {
  int id = 0;
  String resultado = '';
  int partido_id = 0;
  VistaResultados({Key? key}) : super(key: key);

  get resultadoId => 0;

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
              title: Text('RESULTADOS'),
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
          SizedBox(height:10),
          FutureBuilder<List<Resultado>>(
            future: fetchResultados(), 
            builder: (context, snapshot){
              if (snapshot.hasData){
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
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
                                BoxIcons.bx_checkbox,
                                size: 50,
                                color: Colors.amber
                              ),
                              title: Text(snapshot.data![index].result,
                                  style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      letterSpacing: 4,
                                      color: Colors.amber)),
                              subtitle: Text(
                                  style: TextStyle(color: Colors.white),
                                  'ID del partido: ${snapshot.data![index].partido_id}'),
                            )
                          ],
                        ),
                      )
                    );
                  }
                  );
                  } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              ));
              }
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Splashaddresultado()));
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 229, 203, 93),
      ),
    );
    
  }
}