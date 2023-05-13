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
  late SqliteService query;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  late Person personToUpdate;
  bool isEditing = false;

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
                  controller: nameController,
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
                  controller: ageController,
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
                      if (formKey.currentState!.validate()) {
                        addOrEditPerson();
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

  Future<void> addOrEditPerson() async {
    String name = nameController.text;
    String age = ageController.text;

    if (isEditing) {
      personToUpdate.age = int.parse(age);
      personToUpdate.name = name;
      await updatePerson(personToUpdate);
    } else {
      Person personToCreate = Person(name: name, age: int.parse(age));
      await addPerson(personToCreate);
    }
    resetData();
    setState(() {});
  }

  Future<int> addPerson(Person person) async {
    return await query.createPerson(person);
  }

  Future<int> updatePerson(Person person) async {
    return await query.updatePerson(person);
  }

  void resetData() {
    nameController.clear();
    ageController.clear();
    isEditing = false;
  }
}

