import 'package:cer2_esportsmanagement/Splash/SplashJugadores.dart';
import 'package:cer2_esportsmanagement/Splash/splashAddEquipos.dart';
import 'package:flutter/material.dart';

class VistaEquipos extends StatelessWidget {
  const VistaEquipos({super.key});

  @override

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
          Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 5,
          color: const Color.fromARGB(255,229,203,93),
          child: ListTile(
            title: Text('%Nombre%', style: TextStyle(fontSize: 20, 
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255,48,25,95))),
            subtitle: Text('Jugadores: %%'),
            leading: Icon(Icons.sports_esports, size: 35, color: const Color.fromARGB(255,48,25,95),),
            trailing: IconButton(
              icon : Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(context) => VerJugadores()));
                //Accion (Splash a info de jugadores)
              }),
            tileColor: const Color.fromARGB(255,229,203,93),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
        ]
      ),
    floatingActionButton: FloatingActionButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder:(context) => AgregarEquipo()));
    },
    child: Icon(Icons.add),
    backgroundColor: const Color.fromARGB(255,229,203,93))
    );
  }
}