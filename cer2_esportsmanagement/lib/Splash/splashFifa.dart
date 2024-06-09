import 'package:flutter/material.dart';

class SplashFifa extends StatelessWidget {
  const SplashFifa({Key? key}) : super(key: key);

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
      body:Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wall.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(5),
          elevation: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Para hacer la Card tan grande como sus hijos
            children: <Widget>[
              ListTile(
                title: Text('Campeonatos'),
                subtitle: Text('Presione el botón para ver los campeonatos disponibles.'),
              ),
              ButtonBar(
                children: <Widget>[
                  FloatingActionButton.small(
                    onPressed: () {
                      // Acción al presionar el botón
                      // Aquí puedes navegar a otra pantalla que muestre los campeonatos disponibles
                    },
                    child: Text('VER'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);
  }
}