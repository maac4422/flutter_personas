import 'package:flutter/material.dart';
import 'package:app_personas/models/person.dart';
import 'package:app_personas/services/sqlite_service.dart';
import 'package:app_personas/screens/shared/bottom_container/bottom_container.dart';

class PersonHobbyList extends StatefulWidget {
  const PersonHobbyList({ Key? key }) : super(key: key);

  @override
  _PersonHobbyListState createState() => _PersonHobbyListState();
}

class _PersonHobbyListState extends State<PersonHobbyList> {
  late SqliteService query;

  @override
  void initState() {
    super.initState();
    query = SqliteService();
    query.initDb().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

