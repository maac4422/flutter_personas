import 'package:flutter/material.dart';
import 'package:app_personas/models/person.dart';
import 'package:app_personas/services/sqlite_service.dart';

class AddEditPerson extends StatefulWidget {
  const AddEditPerson({ Key? key }) : super(key: key);

  @override
  _AddEditPersonState createState() => _AddEditPersonState();
}

class _AddEditPersonState extends State<AddEditPerson> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SqliteService query = SqliteService();
  String name = '';
  int age = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 250, 252, 1.0),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(94, 114, 228, 1.0),
          elevation: 0.0,
          title: const Text('Add or edit a person'),
        ),
        body:Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  onSaved: (String? value){name=value!;},
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  onSaved: (String? value){age=value! as int;},
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Age',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the age';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (formKey.currentState!.validate()) {
                        Person personToSave = Person(id: null,name: name,age: age);
                        query.createPerson(personToSave);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          )
        )
    );
  }
}