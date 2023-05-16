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
  SqliteService query = SqliteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 250, 252, 1.0),
      body: Column(
        children:[
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                subheading('People'),
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const AddEditPerson(),
                                        settings: RouteSettings(
                                          arguments: {'person': Person(name: '', age: 0)})
                                      ),
                                    ).then((value) => query.getPeople());
                                  },
                                  child: addIcon(),
                                ),
                              ],
                            ),
                          ]
                      )
                  ),
                  FutureBuilder<List<Person>>(
                      future: query.getPeople(),
                      initialData: const [],
                      builder: (context, snapshot) {
                        return snapshot.hasData ?
                        ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(10.0),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, i) {
                            return _buildRow((snapshot.data![i]));
                          },
                        ) : const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                  )
                ],
              )
          )
          ),
          BottomContainer()
        ]
      )
    );
  }

  static CircleAvatar addIcon() {
    return const CircleAvatar(
      radius: 25.0,
      backgroundColor: Color.fromRGBO(94, 114, 228, 1.0),
      child: Icon(
        Icons.add,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: Color.fromRGBO(94, 114, 228, 1.0),
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  Widget _buildRow(Person person) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: const Icon(Icons.delete_forever),
      ),
      key: UniqueKey(),
      onDismissed: (DismissDirection direction) async {
        await query.deletePerson(person.id!);
        const toastMessage = 'Person deleted' ;
        var snackBar = const SnackBar(content: Text(toastMessage));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditPerson(),
              settings: RouteSettings(
                arguments: {'person': person}
              )
            ),
          );
        },
        child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                        child: Text(
                          person.name,
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                        child: Text(
                          "Age: ${person.age.toString()}",
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ]
                  )
                ]
              )
            ]
        )
      )
    );
  }
}