// import 'package:cer2_esportsmanagement/Add/Pruebas.dart';
import 'package:cer2_esportsmanagement/Vistas/principal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          //255,48,25,95
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromARGB(255, 48, 25, 95),
              foregroundColor: Colors.white,
              centerTitle: true),
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 48, 25, 95)),
          useMaterial3: true,
        ),
        home: PaginaPrincipal());
  }
}
