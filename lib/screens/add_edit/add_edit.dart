import 'package:flutter/material.dart';
import 'package:app_personas/models/person.dart';
import 'package:app_personas/services/sqlite_service.dart';
import 'package:app_personas/screens/shared/bottom_container/bottom_container.dart';
import 'package:app_personas/screens/add_edit/add_hobby.dart';

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
  late Map args = ModalRoute.of(context)?.settings.arguments as Map;
  late Person? personToUpdate = args['person'];
  late List<String> hobbiesToAdd = [];
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
    if(personToUpdate?.id != null) {
      nameController.text = personToUpdate!.name;
      ageController.text = personToUpdate!.age.toString();
      isEditing = true;
    }

    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 250, 252, 1.0),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(94, 114, 228, 1.0),
          elevation: 0.0,
          title: const Text('Add or edit a person'),
        ),
        body: Column(
          children:[
            Expanded(
                child:Container(
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
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async{
                                  if (formKey.currentState!.validate()) {
                                    final toastMessage = isEditing ? 'Person updated' : 'Person created';
                                    await addOrEditPerson();
                                    var snackBar = SnackBar(content: Text(toastMessage));
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      Navigator.pop(context, 'newUser');
                                    }
                                  }
                                },
                                child: Text(isEditing ? 'Edit' : 'Save'),
                              ),
                              addHobbyButton(),
                              hobbiesList()
                            ],
                          )
                        ),
                      ],
                    ),
                  )
                )
            ),
            BottomContainer(),
          ]
        ),
    );
  }

  Future<void> addOrEditPerson() async {
    String name = nameController.text;
    String age = ageController.text;

    if (isEditing) {
      final Person updatedPerson = Person(id: personToUpdate!.id,name: name,age: int.parse(age));
      await updatePerson(updatedPerson!);
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

  Widget addHobbyButton() {
    return  ElevatedButton(
        onPressed: () async {
          String hobbyToAdd = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return addHobbyAlert();
              }
          );
          setState(() {
            hobbiesToAdd = List.from(hobbiesToAdd)..add(hobbyToAdd);
          });
        },
        child: const Text('Add Hobby')
    );
  }

  void resetData() {
    nameController.clear();
    ageController.clear();
    isEditing = false;
  }

  Widget addHobbyAlert() {
    return AlertDialog(
        title: const Text("Add hobby"),
        content: Stack(
            clipBehavior: Clip.none,
            children: const <Widget>[
              AddHobby()
            ]
        )
    );
  }

  Widget hobbiesList() {
    return(
      ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
        itemCount: hobbiesToAdd.length,
        itemBuilder: (context, i) {
          return _buildHobbyRow(i,hobbiesToAdd[i]);
        },
      )
    );
  }

  Widget _buildHobbyRow(int key,String hobby) {
    return Dismissible(
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: const Icon(Icons.delete_forever),
        ),
        key: UniqueKey(),
        onDismissed: (DismissDirection direction) {
          setState(() {
            hobbiesToAdd = List.from(hobbiesToAdd)..removeAt(key);
          });

        },
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
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
                                  hobby,
                                  style: const TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold
                                  ),
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

