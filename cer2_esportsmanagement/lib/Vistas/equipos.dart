import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';




class VistaEquipos extends StatefulWidget {
  const VistaEquipos({Key? key}) : super(key: key);

  @override
  State<VistaEquipos> createState() => _VistaEquiposState();
}

class _VistaEquiposState extends State<VistaEquipos>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _buttonAnimatedIcon;


  late Animation<double> _translateButton;

  bool _isExpanded = false;

  @override
  initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() {
        setState(() {});
      });

    _buttonAnimatedIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _translateButton = Tween<double>(
      begin: 100,
      end: -20,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _toggle() {
    if (_isExpanded) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    _isExpanded = !_isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EQUIPOS'),
        titleTextStyle: TextStyle(
        fontFamily: 'Outfit',
        fontSize: 22,
        letterSpacing: 4
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
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
              //Accion (Slash a info de jugadores)
            },),
          tileColor: const Color.fromARGB(255,229,203,93),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Transform(
            transform: Matrix4.translationValues(
              0.0,
              _translateButton.value * 3,
              0.0,
            ),
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255,23,184,255),
              onPressed: () {/* Accion */},
              child: const Icon(
                BoxIcons.bx_message_add,
              ),
            ),
          ),
          Transform(
            transform: Matrix4.translationValues(
              0,
              _translateButton.value * 2,
              0,
            ),
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255,229,203,93),
              onPressed: () {/* Accion */},
              child: const Icon(BoxIcons.bx_pencil),
            ),
          ),

          FloatingActionButton(
            backgroundColor: Color.fromARGB(255,48,25,95),
            onPressed: _toggle,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              color: Colors.white,
              progress: _buttonAnimatedIcon,
            ),
          ),
        ],
      ),
    )
    ;
  }
}