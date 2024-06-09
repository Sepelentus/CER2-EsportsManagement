import 'package:flutter/material.dart';

class AgregarEquipo extends StatefulWidget {
  const AgregarEquipo({super.key});

  @override
  _AgregarEquipoState createState() => _AgregarEquipoState();
}

class _AgregarEquipoState extends State<AgregarEquipo> {
  List<Widget> playerFields = [];
  int playerCount = 1;

  void initState() {
    super.initState();
    playerFields.add(
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Nombre del jugador 1',
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

    void addPlayerField() {
    if (playerCount < 5) {
      setState(() {
        playerFields.add(
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Nombre del jugador ${playerCount + 1}',
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        );
        playerCount++;
      });
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
            title: Text('Agregar Equipos'),
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
        Card(
          margin: EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wall.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Nombre del equipo',
                        filled: true,
                                fillColor: const Color.fromARGB(255, 255, 255, 255),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                      ),
                    ),
                  ),
                  Divider(
                    color: const Color.fromARGB(255,229,203,93),
                    thickness: 2,
                    indent: 30,
                    endIndent: 30,
                  ),
                  
                  ...playerFields,
                  if (playerCount < 5)
                    ElevatedButton(
                      onPressed: addPlayerField,
                      child: Text('Añadir jugador'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    floatingActionButton: Container(
  alignment: Alignment.bottomCenter,
  child: FloatingActionButton(
    onPressed: () {
      // Acción al presionar el botón
    },
    child: Icon(Icons.add),
  ),
),
  );
}
}