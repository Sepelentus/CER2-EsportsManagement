import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarEquipo extends StatefulWidget {
  @override
  _AgregarEquipoState createState() => _AgregarEquipoState();
}

class _AgregarEquipoState extends State<AgregarEquipo> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  String id= '';
  String nombre= '';

  Future<void> saveTeamName(String nombre, String id) async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/equipos/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nombre': nombreController.text,
          'id': "0",
        }),
      );

      if (response.statusCode != 200) {
        print(
            'Failed to save team name. Server responded with: ${response.body}');
        throw Exception('Failed to save team name');
      }


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
              title: Text('AÑADIR EQUIPOS'),
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
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del equipo',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 48, 25, 95),
                      prefixIcon:
                          Icon(Icons.group, color: Colors.amber),
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
                        return 'Por favor, ingrese un nombre';
                      }
                      if (value.length < 3) {
                        return 'El nombre debe tener al menos 3 caracteres';
                      }
                      if (value.length > 20) {
                        return 'El nombre no puede tener más de 20 caracteres';
                      }
                      if (value.contains(RegExp(r'[0-9]'))) {
                        return 'El nombre no puede contener números';
                      }
                      return null;
                    
                    },
                    onChanged: (value) {
                    
                      nombre = value;
                      id = '0';
                    },
                  ),
                  SizedBox(height: 20),
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
                        await saveTeamName(nombre, id);
                        setState(() {
                        });
                    },
                    
                    child: Text('Añadir Equipo', style: TextStyle(color: Colors.amber),
                  )),
                ],
              ),
            ),
            
          ),
          
        ],
      ),
    );
  }
}
