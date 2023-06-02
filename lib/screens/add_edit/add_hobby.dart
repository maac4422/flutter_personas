import 'package:flutter/material.dart';
import 'package:app_personas/models/person.dart';
import 'package:app_personas/services/sqlite_service.dart';
import 'package:app_personas/screens/shared/bottom_container/bottom_container.dart';

class AddHobby extends StatefulWidget {
  const AddHobby({ Key? key }) : super(key: key);

  @override
  _AddHobbyState createState() => _AddHobbyState();
}

class _AddHobbyState extends State<AddHobby> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late SqliteService query;
  final hobbyNameController = TextEditingController();
  late Map args = ModalRoute.of(context)?.settings.arguments as Map;

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

    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 250, 252, 1.0),
      body: Column(
          children:[
            Expanded(
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                controller: hobbyNameController,
                                decoration: const InputDecoration(
                                  hintText: 'Hobby name',
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the hobby name';
                                  }
                                  return null;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton(
                                  onPressed: () async{
                                    if (formKey.currentState!.validate()) {
                                      if (context.mounted) {
                                        Navigator.pop(context, hobbyNameController.text);
                                      }
                                    }
                                  },
                                  child: const Text('Add'),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                )
            )
          ]
      ),
    );
  }
}

