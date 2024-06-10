import 'package:cer2_esportsmanagement/Splash/splashcampeonatos.dart';
import 'package:cer2_esportsmanagement/Vistas/calendarios.dart';
//import 'package:cer2_esportsmanagement/Vistas/campeonatos.dart';
import 'package:cer2_esportsmanagement/Vistas/resultados.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);


  //VISTAS CAMPEONATOS LISTADO DE CAMPEONATOS DISPONIBLES Y DETALLES
  //VISTA LISTADO DE EQUIPOS QUE PARTICIPAN EN EL CAMPEONATO Y DETALLES
  //LISTADO DE CALENDARIO DE PARTIDOS Y DETALLES
  //VISTA DE RESULTADOS DE PARTIDOS Y CLASIFICACION 

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            height: 80,
            child: Image.asset(
              'assets/images/EAS.png',
              fit: BoxFit.contain,
            ),
          ),
          bottom: TabBar(
            //255,23,184,255
            labelColor: const Color.fromARGB(255,229,203,93),
            unselectedLabelColor: Colors.white60,
            indicatorColor: const Color.fromARGB(255,23,184,255),
            tabs: [Tab(icon: Icon(BoxIcons.bx_trophy)), Tab(icon: Icon(BoxIcons.bx_notepad)), Tab(icon: Icon(BoxIcons.bx_calendar))],
          ),
        ),
        body: TabBarView(
          children: [SplashCampeonatos(), VistaResultados(), VistaCalendarios()],
        ),
      ),
    );
  }
}