import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VistaPruebas extends StatelessWidget {
  const VistaPruebas({Key? key}) : super(key: key);
  
  get id => 0;

  Future<List<dynamic>> fetchFromAPI(String endpoint) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/$endpoint'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> fetchTeamsInChampionships() async {
    final championships = await fetchFromAPI('Campeonatos');
    final List<dynamic> teams = [];
    for (var championship in championships) {
      final matches = await fetchFromAPI('partidos');
      final championshipMatches = matches.where((match) => match['campeonato_id'] == int.parse(championship['id']));
      for (var match in championshipMatches) {
        for (var teamId in match['equipos_ids']) {
          final team = await fetchFromAPI('equipos/$teamId');
          if (!teams.any((t) => t['id'] == team[id])) {
            teams.add(team);
          }
        }
      }
    }
    return teams;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchTeamsInChampionships(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]['nombre']),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}