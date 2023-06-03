import 'package:app_personas/screens/hobbies_statistics/hobbies_statistics.dart';
import 'package:app_personas/screens/people_list/people_list.dart';
import 'package:app_personas/screens/shared/bottom_container/bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:app_personas/screens/add_edit/add_edit.dart';
import 'package:app_personas/models/person.dart';
import 'package:app_personas/services/sqlite_service.dart';


class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 250, 252, 1.0),
      body: renderTabs()
    );
  }

  Widget renderTabs() {
    return (
        DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.people)),
                  Tab(icon: Icon(Icons.bar_chart_sharp)),
                ],
              ),
              title: const Text('Tabs Demo'),
            ),
            body: const TabBarView(
              children: [
                PeopleList(),
                HobbiesStatistics(),
              ],
            ),
          ),
        )
    );
  }
}