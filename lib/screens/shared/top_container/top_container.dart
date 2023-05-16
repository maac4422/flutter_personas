import 'package:flutter/material.dart';
import 'package:app_personas/services/sqlite_service.dart';
import 'package:app_personas/models/person.dart';
import 'package:collection/collection.dart';

class TopContainer extends StatelessWidget {
  TopContainer({super.key});
  SqliteService query = SqliteService();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(94, 114, 228, 1.0),
      ),
      child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FutureBuilder<List<Person>>(
                future: query.getPeople(),
                builder: (context, snapshot) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        peopleRegistered(snapshot.data?.length),
                        averageAge(snapshot.data)
                      ]
                  );
                }
              ),
            ]
        )
      ),
    );
  }

  Widget peopleRegistered(int? peopleLength) {
    int peopleRegistered = peopleLength ?? 0;
    return Text(
      'Number of people registered: $peopleRegistered',
      style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
    );
  }

  Widget averageAge(List<Person>? people) {
    double averageAge = 0;
    if(people != null && people.isNotEmpty) {
      averageAge = people.fold(0, (sum, person) => sum + person.age );
      averageAge = people.map((person) => person.age!).average;
    }
    return Text(
      'Average Age: $averageAge',
      style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
    );
  }
}